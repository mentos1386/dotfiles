" Run PlugInstall if there are missing plugins
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

"""""
"--- Plugins
call plug#begin()

" Dependencies by multiple plugins
Plug 'nvim-lua/plenary.nvim'
" General
Plug 'ojroques/vim-oscyank'
Plug 'tpope/vim-obsession'
Plug 'tmux-plugins/vim-tmux-focus-events'
" Look
Plug 'nvim-lualine/lualine.nvim'
Plug 'sainnhe/edge'
Plug 'Yggdroot/indentLine'
Plug 'koenverburg/peepsight.nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'j-hui/fidget.nvim'
" Git
Plug 'lewis6991/gitsigns.nvim'
" Search/Files
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'ANGkeith/telescope-terraform-doc.nvim'
Plug 'fannheyward/telescope-coc.nvim'
Plug 'FeiyouG/commander.nvim'
" Ignore/Edit files
Plug 'vim-scripts/gitignore'
" Languages
Plug 'NoahTheDuke/vim-just'
" Coding helpers
Plug 'zbirenbaum/copilot.lua'
Plug 'zbirenbaum/copilot-cmp'
Plug 'Exafunction/codeium.nvim'
Plug 'petertriho/cmp-git'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'mhartington/formatter.nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
Plug 'onsails/lspkind.nvim'
Plug 'folke/trouble.nvim'

call plug#end()

"""""
"--- TMUX/Clipboard fixes
set t_Co=256
set t_ut=
" Set Vim-specific sequences for RGB colors
" Fixes 'termguicolors' usage in vim+tmux
" :h xterm-true-color
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
" Enables 24-bit RGB color in the terminal
if has('termguicolors')
  if empty($COLORTERM) || $COLORTERM =~# 'truecolor\|24bit'
    set termguicolors
  endif
endif
" Use system clipboard to get buffers synced between TMUX and VIM
if has('clipboard') && has('vim_starting')
  " set clipboard& clipboard+=unnamedplus
  set clipboard& clipboard^=unnamed,unnamedplus
endif
if exists('##TextYankPost')
  augroup BlinkClipboardIntegration
    autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankRegister +' | endif
    autocmd TextYankPost * if v:event.operator is 'd' && v:event.regname is '' | execute 'OSCYankRegister +' | endif
  augroup END
endif

"""""
"--- Misc
augroup JsonToJsonc
    autocmd! FileType json set filetype=jsonc
augroup END

au BufRead,BufNewFile *.mdx setfiletype markdown


"""""
"--- VIM Configuration
set encoding=UTF-8
set autoread " will re-read opened file if changed externally
set autowrite
set splitright
set splitbelow

" Use spaces (2) instead of tabs
set autoindent
set smartindent
set expandtab
set tabstop    =2
set softtabstop=2
set shiftwidth =2

set noswapfile
set nobackup
set nowritebackup
set incsearch " search as you type
set ignorecase
set smartcase
set mouse=a
"set spell spelllang=en_us
set updatetime=300
set cmdheight=1
set hidden
set shortmess+=c

"""""
" Custom configurations
lua require('code_helpers')
lua require('code_look')

"""""
"--- Fidget
lua <<EOF
require("fidget").setup {
  notification = {
    override_vim_notify = true,
  },
}
EOF

"""""
"--- Telescope Configuration
lua <<EOF
require'telescope'.setup {
  defaults = {
    layout_strategy = 'vertical',
  },
  extensions = {
    terraform_doc = {
      url_open_command = "xdg-open",
      latest_provider_symbol = "  ",
      wincmd = "botright new",
      wrap = "nowrap",
    }
  }
}
require'telescope'.load_extension('terraform_doc')
EOF

"""""
"- Keybindings
" Using SPACE as <leader> key
nnoremap <SPACE> <Nop>
let mapleader = " "
lua require('keybindings')


"""""
"- Visuals
set termguicolors
set noshowmode
set number
set cursorline
set hlsearch " highlight all results
set signcolumn=number " always show git diff column
set background=light
let g:edge_enable_italic = 1
let g:edge_background = 'hard'
let g:edge_diagnostic_line_highlight = 1
let g:edge_better_performance = 1
colorscheme edge

lua << END
require('lualine').setup({
  options = {
    theme = 'edge',
    section_separators = {'', ''},
    component_separators = {'', ''},
    icons_enabled = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {'filename'},
    lualine_x = {'diagnostics', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
})
END
