#!/usr/bin/env bash
# Removes what install.sh set up on macOS arm64 or Linux aarch64, after one
# y/N (default N). Works piped (curl ... | bash -s -- --dry-run) or from a
# clone, so it never reads its own path or sibling files. All logic runs inside
# main, called on the last line: a truncated download defines functions and
# runs nothing. Every mutating command goes through run, so --dry-run changes
# nothing. It never removes the config clone or anything outside its fixed
# name list. Re-running is safe: the package record goes last.
set -euo pipefail

# Keep in sync with install.sh step_deps: the only packages it installs
APT_PKGS='build-essential git curl fd-find clangd-18'
BREW_PKGS='ripgrep fd'

DRY=0
YES=0
TTY=0
OS=
MGR=
WL=
BINS='nvim tree-sitter node corepack pnpm pnpx pyright pyright-langserver lua-language-server'
OPTS='node pnpm lua-language-server'
REC=0
PKGS=
MCPHUB=0
COUNT=0
DO_PKGS=0
DO_MCP=0
REMOVED=
SKIPPED=
LEFT=
FAILED=
NEXT=

ORIG_PATH=$PATH
# pnpm rm -g needs the install-time global bin dir on PATH, as install.sh had it
export PATH="$HOME/.local/bin:$PATH"
# Every path below is fixed to nvim; NVIM_APPNAME must not move any of them
unset NVIM_APPNAME
L=$HOME/.local/bin
O=$HOME/.local/opt
CFG=${XDG_CONFIG_HOME:-$HOME/.config}/nvim
DATA=${XDG_DATA_HOME:-$HOME/.local/share}/nvim
CACHE=${XDG_CACHE_HOME:-$HOME/.cache}/nvim
# Keep in sync with install.sh; holds the package record, so it goes last
STATE=${XDG_STATE_HOME:-$HOME/.local/state}/nvim

say() { printf '%s\n' "$*"; }
warn() {
  printf 'warning: %s\n' "$*" >&2
  NEXT="$NEXT  $*"$'\n'
}
die() {
  printf 'uninstall.sh: %s\n' "$*" >&2
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
# Prompts read /dev/tty: under curl | bash, stdin is the script itself
prompt() {
  printf '%s ' "$1" >&2
  read -r REPLY </dev/tty || REPLY=
}
yes_reply() {
  case $REPLY in
    y | Y | yes) return 0 ;;
  esac
  return 1
}

usage() {
  cat <<'EOF'
Usage: uninstall.sh [options]
  -h, --help  show this help
  --dry-run   print the plan and every command, change nothing, ask nothing
  --yes       answer yes to the main prompt only. Unlike install.sh's --yes,
              it never removes apt/brew packages or mcp-hub: those stay
Removes install.sh's fixed list of ~/.local entries (links and wrappers checked
by target or content; the ~/.local/opt dirs, tree-sitter and Linux rg by name
only) and the nvim data, cache and state dirs. Keeps ~/.config/nvim and
everything outside that list.
EOF
}
bad() {
  printf 'uninstall.sh: %s\n' "$*" >&2
  usage >&2
  exit 2
}

# True when ~/.local/bin/$1 is what install.sh writes there. Plain readlink,
# matched as a string: works for dangling links. Keep in sync with install.sh
bin_is_ours() {
  local f=$L/$1
  if [ -L "$f" ]; then
    case $1:$(readlink "$f") in
      nvim:"$HOME/.local/opt/nvim-macos-arm64/bin/nvim" | nvim:"$HOME/.local/opt/nvim-linux-arm64/bin/nvim" | \
        node:"$HOME/.local/opt/node/bin/node" | corepack:"$HOME/.local/opt/node/bin/corepack" | \
        pnpm:"$HOME/.local/opt/pnpm/pnpm" | \
        pnpm:../opt/node/lib/node_modules/corepack/dist/pnpm.js | pnpx:../opt/node/lib/node_modules/corepack/dist/pnpx.js | \
        fd:/usr/bin/fdfind | clangd:/usr/bin/clangd-18)
        return 0
        ;;
    esac
    return 1
  fi
  [ -f "$f" ] || return 1
  case $1 in
    # ponytail: plain files, proven by name only; a --version provenance check is the upgrade path
    tree-sitter | rg) return 0 ;;
    lua-language-server)
      [ "$(cat "$f")" = "$(printf '#!/bin/sh\nexec "%s" "$@"\n' "$HOME/.local/opt/lua-language-server/bin/lua-language-server")" ]
      ;;
    # pnpm's shims name the package path they run
    pyright) grep -qF /node_modules/pyright/index.js "$f" ;;
    pyright-langserver) grep -qF /node_modules/pyright/langserver.index.js "$f" ;;
    *) return 1 ;;
  esac
}

# Calls $1 with every existing path this script owns, in removal order:
# ~/.local/bin entries proven ours, then the fixed ~/.local/opt dirs
each_local() {
  local n
  for n in $BINS; do
    if { [ -L "$L/$n" ] || [ -e "$L/$n" ]; } && bin_is_ours "$n"; then
      "$1" "$L/$n"
    fi
  done
  for n in $OPTS; do
    if [ -L "$O/$n" ] || [ -e "$O/$n" ]; then
      "$1" "$O/$n"
    fi
  done
}
# State last: it holds the package record, so an interrupted run can re-run
each_nvim_dir() {
  local d
  for d in "$CACHE" "$DATA" "$STATE"; do
    if [ -L "$d" ] || [ -e "$d" ]; then
      "$1" "$d"
    fi
  done
}
plan_add() {
  say "  $1"
  COUNT=$((COUNT + 1))
}
remove() {
  if run rm -rf "$1"; then
    REMOVED="$REMOVED $1"
  else
    warn "could not remove $1"
    FAILED="$FAILED $1"
  fi
}

# Display only: nothing found here ever reaches rm
left_alone() {
  local f w
  for f in "$L"/*; do
    [ -L "$f" ] || [ -e "$f" ] || continue
    case " $BINS " in
      *" ${f##*/} "*) if bin_is_ours "${f##*/}"; then continue; fi ;;
    esac
    say "  $f"
    LEFT="$LEFT $f"
  done
  for f in "$O"/*; do
    [ -L "$f" ] || [ -e "$f" ] || continue
    case " $OPTS " in
      *" ${f##*/} "*) continue ;;
    esac
    say "  $f"
    LEFT="$LEFT $f"
  done
  for f in nvim pyright; do
    w=$(
      PATH=$ORIG_PATH
      hash -r
      command -v "$f" || true
    )
    case $w in
      '' | "$L"/* | "$O"/*) ;;
      *)
        say "  $w"
        LEFT="$LEFT $w"
        ;;
    esac
  done
}

# Same check as install.sh step_deps
pkg_present() {
  if [ "$MGR" = apt ]; then
    case "$(dpkg-query -W -f='${db:Status-Status}' "$1" 2>/dev/null || true)" in
      installed | triggers-awaiting | triggers-pending) return 0 ;;
    esac
    return 1
  fi
  brew list --formula --versions "$1" >/dev/null 2>&1
}
# Recorded, whitelisted for this OS and still installed. Without a record:
# whitelisted and installed, for a hint only (REC=0)
read_record() {
  local mgr name
  if [ -f "$STATE/install-packages" ]; then
    REC=1
    while read -r mgr name; do
      [ "$mgr" = "$MGR" ] || continue
      case " $WL " in
        *" $name "*) ;;
        *) continue ;;
      esac
      case " $PKGS " in
        *" $name "*) continue ;;
      esac
      # Without brew every formula looks absent, and the record goes with $STATE
      if [ "$MGR" = brew ] && ! command -v brew >/dev/null; then
        warn "brew is not on PATH: cannot check the recorded package $name; remove it with Homebrew if unused"
        continue
      fi
      if pkg_present "$name"; then
        PKGS="$PKGS $name"
      fi
    done <"$STATE/install-packages"
  else
    for name in $WL; do
      if pkg_present "$name"; then
        PKGS="$PKGS $name"
      fi
    done
  fi
}
# Under --yes only the names: a --yes run never shows a package-removal command
pkg_cmd() {
  if [ "$YES" = 1 ]; then
    printf '%s%s' "$MGR" "$PKGS"
  elif [ "$MGR" = apt ]; then
    printf 'sudo apt-get remove%s' "$PKGS"
  else
    printf 'HOMEBREW_NO_AUTOREMOVE=1 brew uninstall --formula%s' "$PKGS"
  fi
}
# No -y: apt's own prompt lists everything else that would go. It reads
# stdin, which under curl | bash is this script
apt_remove() {
  # $PKGS is a word list of whitelisted names on purpose
  sudo apt-get -o DPkg::Lock::Timeout=300 remove $PKGS </dev/tty
}
# brew: one formula per call, so one with dependents does not stop the rest
# Afterwards PKGS holds only the formulae that failed, for the failed bucket and the printed command
remove_pkgs() {
  local f left=
  if [ "$MGR" = apt ]; then
    run apt_remove
    return
  fi
  for f in $PKGS; do
    if run env HOMEBREW_NO_AUTOREMOVE=1 brew uninstall --formula "$f"; then
      REMOVED="$REMOVED $f"
    else
      left="$left $f"
    fi
  done
  PKGS=$left
  [ -z "$left" ]
}

# Keep in sync with install.sh restore_plugins: mcphub's build ran pnpm add -g
# with these, and pnpm 11+ refuses ls/rm -g without a global bin dir
pnpm_g() {
  npm_config_global_bin_dir="${PNPM_HOME:-$HOME/.local/bin}" pnpm_config_global_bin_dir="$HOME/.local/bin" pnpm "$@"
}
# pnpm_g rm -g mcp-hub as a command to paste: a bare pnpm rm -g fails on pnpm 11+
MCP_RM='npm_config_global_bin_dir="${PNPM_HOME:-$HOME/.local/bin}" pnpm_config_global_bin_dir="$HOME/.local/bin" pnpm rm -g mcp-hub'
has_mcphub() {
  local out
  command -v pnpm >/dev/null || return 1
  out=$(pnpm_g ls -g --depth=0 --parseable 2>/dev/null) || return 1
  case $'\n'"$out"$'\n' in
    *'/node_modules/mcp-hub'$'\n'*) return 0 ;;
  esac
  return 1
}

summary() {
  local f
  say '==> summary'
  if [ "$DRY" = 1 ]; then
    say "would remove:${REMOVED:- none}"
  else
    say "removed:${REMOVED:- none}"
  fi
  say "skipped:${SKIPPED:- none}"
  say "left alone:${LEFT:- none}"
  if [ -n "$FAILED" ]; then
    say "failed:$FAILED"
  fi
  say 'next steps:'
  printf '%s' "$NEXT"
  # %q: the pasted command must name exactly $CFG, spaces included
  printf '  %s was kept; delete it with: rm -rf %q\n' "$CFG" "$CFG"
  case ":$ORIG_PATH:" in
    *":$HOME/.local/bin:"*) say '  if you added export PATH="$HOME/.local/bin:$PATH" to your shell rc for this config, you can remove it (rc files are never edited)' ;;
  esac
  for f in "$HOME/.cache/node/corepack" "$HOME/.local/share/pnpm" "$HOME/Library/pnpm" "$HOME/.local/.crates.toml" "$HOME/.local/.crates2.json"; do
    if [ -e "$f" ]; then
      say "  $f is shared with other tools; delete it by hand if unused"
    fi
  done
  # A dry run ends with this line
  if [ "$DRY" = 1 ]; then
    say 'dry run: nothing changed'
  fi
}

main() {
  local p d
  while [ $# -gt 0 ]; do
    case $1 in
      -h | --help)
        usage
        exit 0
        ;;
      --yes) YES=1 ;;
      --dry-run) DRY=1 ;;
      *) bad "unknown option: $1" ;;
    esac
    shift
  done

  [ "$(id -u)" != 0 ] || die 'refusing to run as root: it removes files in your home; run it as your user'
  OS=$(uname -s)
  case $OS/$(uname -m) in
    Darwin/arm64)
      MGR=brew
      WL=$BREW_PKGS
      OPTS="nvim-macos-arm64 $OPTS"
      ;;
    Linux/aarch64)
      MGR=apt
      WL=$APT_PKGS
      BINS="$BINS fd clangd rg"
      OPTS="nvim-linux-arm64 $OPTS"
      ;;
    *) die "unsupported platform $OS/$(uname -m) (supported: Darwin/arm64, Linux/aarch64)" ;;
  esac
  # These reach rm -rf
  case $HOME in
    /?*) ;;
    *) die "HOME must be an absolute path other than /: '$HOME'" ;;
  esac
  [ -d "$HOME" ] || die "HOME is not a directory: $HOME"
  for p in "$DATA" "$CACHE" "$STATE"; do
    case $p in
      /?*/nvim) ;;
      *) die "refusing to remove $p: XDG_DATA_HOME, XDG_CACHE_HOME and XDG_STATE_HOME must be absolute paths" ;;
    esac
    # Same-file test, not a string match: a trailing slash, // or a symlink in p still
    # names the config. p must not be the config or a parent, walking up from it as
    # spelled and from its physical path (pwd -P), since a symlinked config can live in p
    for d in "$CFG" "$(CDPATH= cd "$CFG" 2>/dev/null && pwd -P)"; do
      while [ -n "$d" ]; do
        [ ! "$d" -ef "$p" ] || die "refusing to remove $p: it holds the config $CFG"
        case $d in
          */*) d=${d%/*} ;;
          *) d= ;;
        esac
      done
    done
  done
  # [ -r /dev/tty ] is true even with no controlling terminal; opening it is not
  if (: </dev/tty) 2>/dev/null; then
    TTY=1
  fi
  [ "$TTY" = 1 ] || [ "$YES" = 1 ] || [ "$DRY" = 1 ] || die 'no terminal for prompts: pass --yes or --dry-run'

  # Read-only from here to the prompts
  read_record
  if has_mcphub; then
    MCPHUB=1
  fi
  say '==> plan'
  say 'will remove:'
  each_local plan_add
  each_nvim_dir plan_add
  if [ "$COUNT" = 0 ]; then
    say '  nothing'
    say 'nothing to remove'
    if [ "$MCPHUB" = 1 ]; then
      say "pnpm global mcp-hub is installed; remove it with: $MCP_RM"
    fi
    exit 0
  fi
  say 'left alone (not installed by install.sh):'
  left_alone
  [ -n "$LEFT" ] || say '  nothing'
  if [ "$REC" = 1 ] && [ -n "$PKGS" ]; then
    say 'will offer (default N):'
    if [ "$YES" = 1 ]; then
      say "  recorded packages $(pkg_cmd): kept, --yes never removes packages"
    else
      say "  $(pkg_cmd)"
    fi
  fi
  if [ "$MCPHUB" = 1 ]; then
    [ "$REC" = 1 ] && [ -n "$PKGS" ] || say 'will offer (default N):'
    if [ "$YES" = 1 ]; then
      say '  pnpm global mcp-hub: kept, --yes never removes it'
    else
      say "  $MCP_RM"
    fi
  fi
  if [ "$MGR" = brew ]; then
    say "This deletes sessions, shada, the profile and the colorscheme of every nvim on this machine, Homebrew's included."
  else
    say 'This deletes sessions, shada, the profile and the colorscheme of every nvim on this machine.'
  fi
  if pgrep -x nvim >/dev/null 2>&1; then
    say 'warning: nvim is running: quit it first, or it may rewrite shada and sessions after removal'
  fi
  say "kept: $CFG"

  if [ "$DRY" = 0 ] && [ "$YES" = 0 ]; then
    prompt 'Remove everything under "will remove"? [y/N]'
    if ! yes_reply; then
      say 'nothing changed'
      exit 0
    fi
    if [ "$REC" = 1 ] && [ -n "$PKGS" ]; then
      case " $PKGS " in
        *' git '* | *' curl '*) say "note: the kept $CFG needs git, and curl ... | bash needs curl" ;;
      esac
      prompt "Also run: $(pkg_cmd)? [y/N]"
      if yes_reply; then
        DO_PKGS=1
      fi
    fi
    if [ "$MCPHUB" = 1 ]; then
      prompt "Also run: $MCP_RM? [y/N]"
      if yes_reply; then
        DO_MCP=1
      fi
    fi
  fi

  say '==> remove'
  # pnpm first: it needs node and pnpm, and removes the shims it wrote. If it
  # fails, the rm below still takes the shims proven ours
  if bin_is_ours pyright || bin_is_ours pyright-langserver; then
    if ! command -v pnpm >/dev/null; then
      warn "pnpm not found: removing the pyright shims only; pnpm's global store may still hold pyright"
    elif run pnpm rm -g --config.global-bin-dir="$HOME/.local/bin" pyright; then
      # pnpm removed the shims itself, so each_local will not list them
      REMOVED="$REMOVED pyright"
    else
      warn "pnpm rm -g pyright failed: removing its shims; pnpm's global store may still hold pyright"
    fi
  fi
  if [ "$DO_MCP" = 1 ] && run pnpm_g rm -g mcp-hub; then
    REMOVED="$REMOVED mcp-hub"
  elif [ "$MCPHUB" = 1 ]; then
    if [ "$DO_MCP" = 1 ]; then
      warn 'pnpm rm -g mcp-hub failed'
      FAILED="$FAILED mcp-hub"
    else
      SKIPPED="$SKIPPED mcp-hub"
    fi
    # Checked before each_local removes it: after this run that pnpm is gone
    if bin_is_ours pnpm; then
      NEXT="$NEXT  mcp-hub stays, and this run removes install.sh's pnpm: reinstall pnpm, then run: $MCP_RM"$'\n'
    else
      NEXT="$NEXT  remove mcp-hub with: $MCP_RM"$'\n'
    fi
  fi
  each_local remove
  if [ -n "$PKGS" ]; then
    # Under --yes pkg_cmd is names only, so point at the package manager instead (D-16)
    if [ "$REC" = 0 ] && [ "$YES" = 1 ]; then
      NEXT="$NEXT  installed, but install.sh may not have installed them (the kept clone needs git): $(pkg_cmd); remove them with your package manager if unused"$'\n'
    elif [ "$REC" = 0 ]; then
      NEXT="$NEXT  installed, but install.sh may not have installed them (the kept clone needs git): $(pkg_cmd)"$'\n'
    elif [ "$DO_PKGS" = 1 ] && remove_pkgs; then
      REMOVED="$REMOVED$PKGS"
    else
      if [ "$DO_PKGS" = 1 ]; then
        FAILED="$FAILED$PKGS"
      else
        SKIPPED="$SKIPPED$PKGS"
      fi
      if [ "$YES" = 1 ]; then
        NEXT="$NEXT  recorded packages kept (--yes never removes packages): $(pkg_cmd); remove them with your package manager"$'\n'
      else
        NEXT="$NEXT  remove the recorded packages with: $(pkg_cmd)"$'\n'
        if [ "$MGR" = apt ]; then
          NEXT="$NEXT  apt autoremove is up to you"$'\n'
        fi
      fi
    fi
  fi
  each_nvim_dir remove
  summary
  [ -z "$FAILED" ] || exit 1
}

main "$@"
