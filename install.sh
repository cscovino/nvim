#!/usr/bin/env bash
# Sets up this Neovim config on macOS arm64 or Linux aarch64.
# Works piped (curl ... | bash), as bash <(curl ...) or from a clone, so it never
# reads its own path or sibling files. All logic runs inside main, called on the
# last line: a truncated download defines functions and runs nothing.
# Every mutating command goes through run, so --dry-run changes nothing.
# Re-running is safe; a failed step aborts and names itself.
set -euo pipefail

NVIM_MIN=0.12.0
NVIM_TAG_RE='^v[0-9]+\.[0-9]+\.[0-9]+$'
# Newest tree-sitter linux-arm64 build that runs below glibc 2.39
TS_PIN=v0.25.10
# Linux tools, pinned so a bump is a one-line change
LUALS_VERSION=3.19.1
RG_VERSION=15.2.0
NODE_DIST=https://nodejs.org/dist/latest-v24.x
PYRIGHT_VERSION=1.1.414
REPO_URL=https://github.com/cscovino/nvim.git

DRY=0
YES=0
ONLY=
PROFILE=
NVIM_VERSION=
STEP=init
OS=
ARCH=
GLIBC=
TTY=0
TMP=
INSTALLED=
SKIPPED=
NEXT=
PROFILE_MSG='not changed'

# Shadow checks must use the user's PATH, not ours
ORIG_PATH=$PATH
# Later steps must find what earlier steps installed
export PATH="$HOME/.local/bin:$PATH"
CFG=${XDG_CONFIG_HOME:-$HOME/.config}/nvim
STATE=${XDG_STATE_HOME:-$HOME/.local/state}/nvim
# lua/profile M.file is stdpath('state')/profile
PROFILE_FILE=$STATE/profile
LOG=$STATE/install.log
LAZY_DIR=${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lazy

say() { printf '%s\n' "$*"; }
warn() {
  printf 'warning: %s\n' "$*" >&2
  NEXT="$NEXT  $*"$'\n'
}
die() {
  printf 'install.sh: %s\n' "$*" >&2
  exit 1
}
# A redirect or pipe on run itself would still execute in dry-run, so anything
# with one is a named function called as run <function>
run() {
  if [ "$DRY" = 1 ]; then
    say "+ $*"
  else
    "$@"
  fi
}
# True when version $1 >= $2
ver_ge() { [ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | sed -n 1p)" = "$2" ]; }
# -f: an HTTP error fails instead of saving an error page
fetch() { run curl -fsSL --retry 3 -o "$2" "$1"; }
# Prompts read /dev/tty: under curl | bash, stdin is the script itself
prompt() {
  printf '%s ' "$1" >&2
  read -r REPLY </dev/tty || REPLY=
}

usage() {
  cat <<'EOF'
Usage: install.sh [options]
  -h, --help                            show this help
  --yes                                 take the default at every prompt
  --dry-run                             print what would be done, change nothing
  --profile full|minimal                write this profile (default: full on macOS, minimal on Linux)
  --nvim-version stable|nightly|vX.Y.Z  the Neovim to install (v0.12.0 or newer)
  --only nvim|deps|lsp|config|plugins   run one step
Without --only and --yes, a menu asks which part to run.
EOF
}
# stable, nightly or a vX.Y.Z tag >= NVIM_MIN. The value reaches a URL, so
# nothing else passes. bash 3.2 matches a quoted regex literally, so it lives
# in a variable
valid_nvim_version() {
  case $1 in
    stable | nightly) return 0 ;;
  esac
  [[ $1 =~ $NVIM_TAG_RE ]] && ver_ge "${1#v}" "$NVIM_MIN"
}
# The tag releases/latest redirects to
latest_tag() {
  local u
  u=$(curl -fsSLo /dev/null -w '%{url_effective}' "https://github.com/$1/releases/latest") ||
    die "could not look up the latest Neovim release on $1"
  u=${u##*/}
  [[ $u =~ $NVIM_TAG_RE ]] || die "unexpected latest Neovim tag on $1: $u"
  printf '%s\n' "$u"
}
# Major version from "$1 --version"; 0 when it fails or prints no number, so
# a broken tool counts as missing
major() {
  local v
  v=$("$1" --version 2>/dev/null) || v=
  v=${v%%$'\n'*}
  v=${v#"${v%%[0-9]*}"}
  v=${v%%[!0-9]*}
  printf '%s\n' "${v:-0}"
}
# A bad flag or value: exit 2 with the usage text
bad() {
  printf 'install.sh: %s\n' "$*" >&2
  usage >&2
  exit 2
}

install_tree_sitter() {
  gunzip -c "$TMP/tree-sitter.gz" >"$HOME/.local/bin/tree-sitter"
  chmod +x "$HOME/.local/bin/tree-sitter"
}

write_luals_wrapper() {
  printf '#!/bin/sh\nexec "%s" "$@"\n' "$HOME/.local/opt/lua-language-server/bin/lua-language-server" \
    >"$HOME/.local/bin/lua-language-server"
  chmod +x "$HOME/.local/bin/lua-language-server"
}

write_profile() {
  mkdir -p "$STATE"
  # The exact bytes lua/profile M.save writes for a bare preset
  printf '{"categories":{},"preset":"%s"}\n' "$1" >"$PROFILE_FILE"
}

# stdin is /dev/null: under curl | bash it is the script itself
restore_plugins() {
  nvim --headless -c 'lua assert(loadstring(vim.env.NVIM_INSTALL_LUA))()' -c 'cquit 9' </dev/null >"$LOG" 2>&1
}

step_deps() {
  local pair bin formula p missing=
  if [ "$OS" = Linux ]; then
    command -v apt-get >/dev/null || die 'apt-get not found: only apt-based Linux is supported'
    for p in build-essential git curl fd-find clangd-18; do
      case "$(dpkg-query -W -f='${Status}' "$p" 2>/dev/null || true)" in
        *'install ok installed'*) ;;
        *) missing="$missing $p" ;;
      esac
    done
    if [ -z "$missing" ]; then
      say 'apt packages present, skipping'
      SKIPPED="$SKIPPED apt"
    else
      if [ "$YES" = 0 ]; then
        prompt "Install with sudo apt-get:$missing? [y/N]"
        case $REPLY in
          y | Y | yes) ;;
          *) die "apt install declined; still missing:$missing" ;;
        esac
      fi
      say "installing with apt-get:$missing"
      # sudo is used for these two lines only. Never apt-get's upgrade: it
      # would upgrade the whole system
      run sudo apt-get update
      # $missing is a word list on purpose
      run sudo env DEBIAN_FRONTEND=noninteractive apt-get -o DPkg::Lock::Timeout=300 install -y $missing ||
        die 'apt-get install failed; fd-find and clangd-18 are in the universe component (sudo add-apt-repository universe), then re-run'
      INSTALLED="$INSTALLED$missing"
    fi
    # Debian names the fd binary fdfind
    if command -v fd >/dev/null; then
      say 'fd present, skipping'
      SKIPPED="$SKIPPED fd"
    else
      run ln -sfn /usr/bin/fdfind "$HOME/.local/bin/fd"
      INSTALLED="$INSTALLED fd"
    fi
  else
    # Only installs what is missing; never upgrades or relinks brew packages
    for pair in rg:ripgrep fd:fd; do
      bin=${pair%%:*}
      formula=${pair#*:}
      if command -v "$bin" >/dev/null; then
        say "$bin present, skipping"
        SKIPPED="$SKIPPED $bin"
      else
        command -v brew >/dev/null || die 'Homebrew not found: install ripgrep and fd, then re-run'
        say "installing $formula with brew"
        run brew install "$formula"
        INSTALLED="$INSTALLED $formula"
      fi
    done
  fi
}

step_nvim() {
  local v ok= want=$NVIM_VERSION latest= tag hint have w
  # Fixed names, never from input: they reach rm -rf
  local dir=nvim-macos-arm64 repo=neovim/neovim
  if [ "$OS" = Linux ]; then
    dir=nvim-linux-arm64
    # neovim/neovim Linux builds need glibc 2.34; neovim-releases targets old glibc
    ver_ge "$GLIBC" 2.35 || repo=neovim/neovim-releases
  fi
  # Even --version creates stdpath('state')/nvim.log, which a dry run must not
  v=$(NVIM_LOG_FILE=/dev/null nvim --version 2>/dev/null) || v=
  v=${v%%$'\n'*}
  case $v in
    'NVIM v'*)
      v=${v#NVIM v}
      v=${v%%[!0-9.]*}
      ;;
    *) v= ;;
  esac
  if [ -n "$v" ] && ver_ge "$v" "$NVIM_MIN"; then
    ok=1
  fi
  if [ -z "$want" ] && [ "$YES" = 0 ]; then
    latest=$(latest_tag "$repo")
    if [ -n "$v" ]; then
      say "Neovim installed: v$v ($(command -v nvim))"
    else
      say 'Neovim installed: none'
    fi
    say "Neovim latest: $latest ($repo)"
    hint=$latest
    if [ -n "$ok" ]; then
      hint="keep v$v"
    fi
    prompt "Neovim version [Enter: $hint | stable | nightly | vX.Y.Z | skip]"
    case $REPLY in
      '') ;;
      skip)
        say 'skipping Neovim'
        SKIPPED="$SKIPPED nvim"
        return 0
        ;;
      *)
        valid_nvim_version "$REPLY" || die "invalid Neovim version: $REPLY (stable, nightly or vX.Y.Z, v$NVIM_MIN or newer)"
        want=$REPLY
        ;;
    esac
  fi
  # D-10, D-11: no choice keeps a working Neovim, else installs stable.
  # Never touches brew's neovim (D-07)
  if [ -z "$want" ] && [ -n "$ok" ]; then
    say "nvim v$v present, keeping (pass --nvim-version to change it)"
    SKIPPED="$SKIPPED nvim"
  else
    case ${want:-stable} in
      stable)
        [ -n "$latest" ] || latest=$(latest_tag "$repo")
        tag=$latest
        ;;
      nightly)
        [ "$repo" = neovim/neovim ] || die 'nightly is only published for glibc >= 2.35 (neovim/neovim); pick stable or a tag'
        tag=nightly
        ;;
      *) tag=$want ;;
    esac
    have=$(NVIM_LOG_FILE=/dev/null "$HOME/.local/bin/nvim" --version 2>/dev/null) || have=
    # A nightly is never up to date
    if [ "$tag" != nightly ] && [ "${have%%$'\n'*}" = "NVIM $tag" ]; then
      say "nvim $tag already installed, skipping"
      SKIPPED="$SKIPPED nvim"
    else
      say "installing Neovim $tag from $repo to $HOME/.local/opt/$dir"
      # Exact asset name: the repos also publish -puc builds
      fetch "https://github.com/$repo/releases/download/$tag/$dir.tar.gz" "$TMP/nvim.tar.gz" ||
        die "Neovim $tag: $dir.tar.gz is not published for this platform on $repo (or the download failed); neovim-releases arm64 builds start at v0.12.3"
      # The top dir stays whole: flattening it into ~/.local mixes its runtime
      # into the data dir's parent
      run mkdir -p "$HOME/.local/opt"
      run tar -xzf "$TMP/nvim.tar.gz" -C "$TMP"
      run rm -rf "$HOME/.local/opt/$dir"
      run mv "$TMP/$dir" "$HOME/.local/opt/$dir"
      if [ "$OS" = Darwin ]; then
        run xattr -cr "$HOME/.local/opt/$dir"
      fi
      run ln -sfn "$HOME/.local/opt/$dir/bin/nvim" "$HOME/.local/bin/nvim"
      if [ "$DRY" = 0 ]; then
        # No grep -q pipe: under pipefail an early exit can fail the pipeline
        have=$(NVIM_LOG_FILE=/dev/null "$HOME/.local/opt/$dir/bin/nvim" --version 2>/dev/null) || have=
        case $have in
          *LuaJIT*) ;;
          *) die 'installed nvim is not a LuaJIT build' ;;
        esac
      fi
      INSTALLED="$INSTALLED nvim $tag"
    fi
  fi
  # D-07: warn only; the other nvim stays
  if [ -e "$HOME/.local/bin/nvim" ]; then
    w=$(
      PATH=$ORIG_PATH
      hash -r
      command -v nvim || true
    )
    if [ -n "$w" ] && [ "$w" != "$HOME/.local/bin/nvim" ]; then
      warn "another nvim wins in your PATH: $w (put ~/.local/bin first, or remove it, e.g. brew uninstall neovim)"
    fi
  fi
}

step_lsp() {
  local v url w b f n22
  v=$(tree-sitter --version 2>/dev/null) || v=
  # No version number counts as missing
  case $v in
    *[0-9].[0-9]*) ;;
    *) v= ;;
  esac
  if [ -n "$v" ]; then
    say "$v present, skipping"
    SKIPPED="$SKIPPED tree-sitter"
  else
    # A release without the .gz asset makes curl -f fail loudly
    if [ "$OS" = Darwin ]; then
      url=https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-macos-arm64.gz
    elif ver_ge "$GLIBC" 2.39; then
      url=https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-arm64.gz
    else
      url=https://github.com/tree-sitter/tree-sitter/releases/download/$TS_PIN/tree-sitter-linux-arm64.gz
    fi
    say "installing tree-sitter to $HOME/.local/bin"
    fetch "$url" "$TMP/tree-sitter.gz"
    run install_tree_sitter
    INSTALLED="$INSTALLED tree-sitter"
    if [ "$DRY" = 0 ]; then
      "$HOME/.local/bin/tree-sitter" --version >/dev/null 2>&1 ||
        die 'the downloaded tree-sitter does not run here; build it instead: CARGO_BUILD_JOBS=2 cargo install --locked tree-sitter-cli'
      w=$(
        PATH=$ORIG_PATH
        hash -r
        command -v tree-sitter || true
      )
      if [ -n "$w" ] && [ "$w" != "$HOME/.local/bin/tree-sitter" ]; then
        warn "$w wins over $HOME/.local/bin/tree-sitter on your PATH; if it is the pnpm one: pnpm rm -g tree-sitter-cli"
      fi
    fi
  fi
  v=$(major node)
  # macOS: the user manages these, so only hint
  if [ "$OS" = Darwin ]; then
    if [ "$v" -ge 22 ]; then
      say "node v$v present"
    else
      warn 'node >= 22 not found (copilot needs it): install it with fnm or brew'
    fi
    for b in pyright-langserver clangd lua-language-server; do
      if command -v "$b" >/dev/null; then
        say "$b present"
      else
        case $b in
          pyright-langserver) warn 'pyright-langserver not found: npm i -g pyright' ;;
          clangd) warn 'clangd not found: xcode-select --install' ;;
          *) warn 'lua-language-server not found: brew install lua-language-server' ;;
        esac
      fi
    done
    return 0
  fi
  # Linux, in this order: pyright needs node, and nothing is tried after a
  # failed smoke test (D-05: a hint, no automatic fallback)
  n22="Install Node 22 from https://nodejs.org/dist/latest-v22.x/ into ~/.local/opt/node (link node, npm, npx into ~/.local/bin), then re-run: node >= 22 is kept"
  if [ "$v" -ge 22 ]; then
    say "node v$v present, skipping"
    SKIPPED="$SKIPPED node"
  else
    f=$(curl -fsSL "$NODE_DIST/SHASUMS256.txt" | sed -n 's/.* \(node-v[0-9.]*-linux-arm64\.tar\.gz\)$/\1/p') || f=
    [ -n "$f" ] || die "no linux-arm64 tarball listed in $NODE_DIST/SHASUMS256.txt"
    say "installing $f to $HOME/.local/opt/node"
    fetch "$NODE_DIST/$f" "$TMP/node.tar.gz"
    run mkdir -p "$HOME/.local/opt"
    run tar -xzf "$TMP/node.tar.gz" -C "$TMP"
    run rm -rf "$HOME/.local/opt/node"
    run mv "$TMP/${f%.tar.gz}" "$HOME/.local/opt/node"
    for b in node npm npx; do
      run ln -sfn "$HOME/.local/opt/node/bin/$b" "$HOME/.local/bin/$b"
    done
    INSTALLED="$INSTALLED node"
    if [ "$DRY" = 0 ]; then
      "$HOME/.local/bin/node" -e 0 >/dev/null 2>&1 ||
        die "Node 24 does not run on this machine (kernel $(uname -r)). $n22"
    fi
  fi
  if command -v pyright-langserver >/dev/null; then
    say 'pyright present, skipping'
    SKIPPED="$SKIPPED pyright"
  else
    say "installing pyright $PYRIGHT_VERSION to $HOME/.local"
    # --prefix: no sudo, no npm configuration change, bins land in ~/.local/bin
    run npm install -g --prefix "$HOME/.local" "pyright@$PYRIGHT_VERSION"
    INSTALLED="$INSTALLED pyright"
    # pyright-langserver --version always exits 1, so test pyright itself
    if [ "$DRY" = 0 ]; then
      pyright --version >/dev/null 2>&1 || die "pyright does not run with this Node. $n22"
    fi
  fi
  if command -v clangd >/dev/null; then
    say 'clangd present, skipping'
    SKIPPED="$SKIPPED clangd"
  else
    if [ "$DRY" = 0 ]; then
      [ -x /usr/bin/clangd-18 ] || die 'clangd-18 is not installed: run with --only deps first'
    fi
    run ln -sfn /usr/bin/clangd-18 "$HOME/.local/bin/clangd"
    INSTALLED="$INSTALLED clangd"
  fi
  if command -v lua-language-server >/dev/null; then
    say 'lua-language-server present, skipping'
    SKIPPED="$SKIPPED lua-language-server"
  else
    say "installing lua-language-server $LUALS_VERSION to $HOME/.local/opt/lua-language-server"
    fetch "https://github.com/LuaLS/lua-language-server/releases/download/$LUALS_VERSION/lua-language-server-$LUALS_VERSION-linux-arm64.tar.gz" "$TMP/luals.tar.gz"
    run rm -rf "$HOME/.local/opt/lua-language-server"
    run mkdir -p "$HOME/.local/opt/lua-language-server"
    # This tarball has no top dir
    run tar -xzf "$TMP/luals.tar.gz" -C "$HOME/.local/opt/lua-language-server"
    run write_luals_wrapper
    INSTALLED="$INSTALLED lua-language-server"
  fi
  # apt-era ripgrep 11 is too old
  v=$(major rg)
  if [ "$v" -ge 15 ]; then
    say "ripgrep $v present, skipping"
    SKIPPED="$SKIPPED rg"
  else
    say "installing ripgrep $RG_VERSION to $HOME/.local/bin"
    fetch "https://github.com/BurntSushi/ripgrep/releases/download/$RG_VERSION/ripgrep-$RG_VERSION-aarch64-unknown-linux-gnu.tar.gz" "$TMP/rg.tar.gz"
    run tar -xzf "$TMP/rg.tar.gz" -C "$TMP"
    run mv "$TMP/ripgrep-$RG_VERSION-aarch64-unknown-linux-gnu/rg" "$HOME/.local/bin/rg"
    INSTALLED="$INSTALLED rg"
  fi
}

step_config() {
  local preset=full
  if [ "$OS" = Linux ]; then
    preset=minimal
  fi
  if [ -d "$CFG" ]; then
    say "config present at $CFG, keeping"
    SKIPPED="$SKIPPED config"
  else
    say "cloning $REPO_URL to $CFG"
    run git clone "$REPO_URL" "$CFG"
    INSTALLED="$INSTALLED config"
  fi
  if [ -f "$PROFILE_FILE" ] && [ -z "$PROFILE" ]; then
    say "profile kept ($PROFILE_FILE)"
    PROFILE_MSG=kept
  else
    preset=${PROFILE:-$preset}
    say "writing profile $preset to $PROFILE_FILE"
    run write_profile "$preset"
    PROFILE_MSG="written ($preset)"
  fi
  # NVIM_PROFILE is never exported: it would drop saved category toggles and
  # let the plugins step's clean delete their plugins
}

step_plugins() {
  local before= after rc=0 names
  # D-01: never re-restore an installed set, that would revert :Lazy update work
  if [ "$ONLY" != plugins ] && [ -n "$(ls -A "$LAZY_DIR" 2>/dev/null)" ]; then
    say "plugins present in $LAZY_DIR, skipping (--only plugins forces a restore)"
    SKIPPED="$SKIPPED plugins"
    return 0
  fi
  if [ "$DRY" = 0 ]; then
    [ -d "$CFG" ] || die "no config at $CFG: run install.sh --only config first"
    command -v nvim >/dev/null || die 'nvim not found: run install.sh --only nvim first'
  fi
  # nvim's exit code says nothing about failed clones, so this checks lazy's
  # own state, then waits on the config's parser build (D-02, D-06)
  read -r -d '' NVIM_INSTALL_LUA <<'EOF' || true
local ok, err = xpcall(function()
  local lazy = require('lazy')
  lazy.restore({ wait = true, show = false })
  local bad = {}
  for _, p in ipairs(lazy.plugins()) do
    if not p._.installed or require('lazy.core.plugin').has_errors(p) then
      bad[#bad + 1] = p.name
    end
  end
  if #bad > 0 then
    io.stderr:write('plugin restore failed: ' .. table.concat(bad, ', ') .. '\n')
    vim.cmd('cquit 1')
  end
  lazy.clean({ wait = true, show = false })
  local ts = require('config.treesitter')
  if ts.task then
    -- A timeout shows up as missing parsers below
    ts.task:pwait(60 * 60 * 1000)
  end
  local have = require('nvim-treesitter').get_installed('parsers')
  local miss = vim.tbl_filter(function(l)
    return not vim.list_contains(have, l)
  end, ts.parsers)
  if #miss > 0 then
    io.stderr:write('parsers not built: ' .. table.concat(miss, ', ') .. '\n')
    vim.cmd('cquit 2')
  end
end, debug.traceback)
if not ok then
  io.stderr:write(err .. '\n')
  vim.cmd('cquit 3')
end
vim.cmd('qa')
EOF
  export NVIM_INSTALL_LUA
  # D-03: compare before and after, the lockfile often has a local diff
  if [ -d "$CFG" ]; then
    before=$(git -C "$CFG" diff -- lazy-lock.json)
  fi
  say "restoring plugins and building parsers (several minutes on a slow machine), log: $LOG"
  run mkdir -p "$STATE"
  run restore_plugins || rc=$?
  if [ "$rc" != 0 ]; then
    tail -n 20 "$LOG" >&2 || true
    names=$(grep -E '^(plugin restore failed|parsers not built):' "$LOG" | tail -n 1) || names=
    if [ "$rc" = 2 ]; then
      die "${names:-parsers not built}; if tree-sitter cannot build them here, use CARGO_BUILD_JOBS=2 cargo install --locked tree-sitter-cli, then re-run with --only plugins"
    fi
    die "${names:+$names; }plugins step failed (log: $LOG); fix it, then re-run with --only plugins"
  fi
  if [ "$DRY" = 0 ]; then
    after=$(git -C "$CFG" diff -- lazy-lock.json)
    [ "$after" = "$before" ] || die "plugins step changed $CFG/lazy-lock.json"
  fi
  INSTALLED="$INSTALLED plugins"
}

summary() {
  local path_line=
  say '==> summary'
  if [ "$DRY" = 1 ]; then
    say 'dry run: nothing changed'
  fi
  say "installed:${INSTALLED:- none}"
  say "skipped:${SKIPPED:- none}"
  say "profile: $PROFILE_MSG"
  case ":$ORIG_PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) path_line=1 ;;
  esac
  if [ -n "$NEXT" ] || [ -n "$path_line" ]; then
    say 'next steps:'
    printf '%s' "$NEXT"
    # Printed for the user to paste; rc files are never edited
    if [ -n "$path_line" ]; then
      say '  export PATH="$HOME/.local/bin:$PATH"'
    fi
  fi
}

main() {
  local s opt
  while [ $# -gt 0 ]; do
    case $1 in
      -h | --help)
        usage
        exit 0
        ;;
      --yes) YES=1 ;;
      --dry-run) DRY=1 ;;
      --only | --profile | --nvim-version)
        [ $# -ge 2 ] || bad "$1 needs a value"
        # Values reach paths and URLs, so only whitelisted ones pass
        case $1 in
          --only)
            case $2 in
              nvim | deps | lsp | config | plugins) ONLY=$2 ;;
              *) bad "invalid --only value: $2" ;;
            esac
            ;;
          --profile)
            case $2 in
              full | minimal) PROFILE=$2 ;;
              *) bad "invalid --profile value: $2" ;;
            esac
            ;;
          --nvim-version)
            valid_nvim_version "$2" || bad "invalid --nvim-version value: $2 (stable, nightly or vX.Y.Z, v$NVIM_MIN or newer)"
            NVIM_VERSION=$2
            ;;
        esac
        shift
        ;;
      *) bad "unknown option: $1" ;;
    esac
    shift
  done

  # Detection runs before any download or file change
  [ "$(id -u)" != 0 ] || die 'refusing to run as root: it would leave root-owned files in your home; run it as your user'
  OS=$(uname -s)
  ARCH=$(uname -m)
  case $OS/$ARCH in
    Darwin/arm64 | Linux/aarch64) ;;
    *) die "unsupported platform $OS/$ARCH (supported: Darwin/arm64, Linux/aarch64)" ;;
  esac
  # getconf exits 64 on macOS, so ask only on Linux
  if [ "$OS" = Linux ]; then
    GLIBC=$(getconf GNU_LIBC_VERSION 2>/dev/null) || GLIBC=
    GLIBC=${GLIBC#glibc }
    case $GLIBC in
      [0-9]*.[0-9]*) ;;
      *) die 'could not read the glibc version (getconf GNU_LIBC_VERSION)' ;;
    esac
    ver_ge "$GLIBC" 2.28 || die "glibc $GLIBC is older than 2.28, which Neovim needs"
  fi

  # [ -r /dev/tty ] is true even with no controlling terminal; opening it is not
  if (: </dev/tty) 2>/dev/null; then
    TTY=1
  fi
  if [ "$TTY" = 0 ]; then
    [ "$YES" = 1 ] || [ -n "$ONLY" ] || die 'no terminal for prompts: pass --yes or --only <step>'
    # Nobody can answer, so prompts take their defaults
    YES=1
  fi
  if [ -z "$ONLY" ] && [ "$YES" = 0 ]; then
    PS3='Install which part? '
    opt=
    # EOF leaves opt empty, which counts as quit
    select opt in everything nvim deps lsp config plugins quit; do
      [ -n "$opt" ] && break
    done </dev/tty || true
    case ${opt:-quit} in
      quit)
        say 'nothing to do'
        exit 0
        ;;
      everything) ;;
      *) ONLY=$opt ;;
    esac
  fi

  TMP=$(mktemp -d)
  trap 'rc=$?; rm -rf "$TMP"; [ "$rc" -eq 0 ] || printf "install.sh: failed during %s (exit %s)\n" "$STEP" "$rc" >&2' EXIT

  [ -d "$HOME/.local/bin" ] || run mkdir -p "$HOME/.local/bin"
  # Fixed order, whatever the flag order or menu pick
  for s in deps nvim lsp config plugins; do
    if [ -z "$ONLY" ] || [ "$ONLY" = "$s" ]; then
      STEP=$s
      say "==> $s"
      "step_$s"
    fi
  done
  STEP=summary
  summary
}

main "$@"
