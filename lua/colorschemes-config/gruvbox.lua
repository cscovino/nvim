local palette = require('gruvbox.palette')

require('gruvbox').setup({
  contrast = 'hard',
  overrides = {
    SignColumn = { bg = palette.dark0_hard },
    GruvboxRedSign = { bg = palette.dark0_hard },
    GruvboxGreenSign = { bg = palette.dark0_hard },
    GruvboxYellowSign = { bg = palette.dark0_hard },
    GruvboxBlueSign = { bg = palette.dark0_hard },
    GruvboxPurpleSign = { bg = palette.dark0_hard },
    GruvboxAquaSign = { bg = palette.dark0_hard },
    GruvboxOrangeSign = { bg = palette.dark0_hard },
  },
})
vim.cmd('colorscheme gruvbox')
