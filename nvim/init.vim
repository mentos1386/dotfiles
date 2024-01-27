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
Plug 'vim-airline/vim-airline'
Plug 'sainnhe/edge'
Plug 'Yggdroot/indentLine'
Plug 'koenverburg/peepsight.nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'j-hui/fidget.nvim'
" Git
Plug 'airblade/vim-gitgutter'
" Search/Files
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'ANGkeith/telescope-terraform-doc.nvim'
Plug 'fannheyward/telescope-coc.nvim'
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

" Telescope
nnoremap <c-p>        <cmd>Telescope git_files<cr>
nnoremap <leader>ff   <cmd>Telescope find_files<cr>
nnoremap <leader>fg   <cmd>Telescope live_grep<cr>
" Telescope git
nnoremap <leader>fgc   <cmd>Telescope git_commits<cr>
nnoremap <leader>fgb   <cmd>Telescope git_branches<cr>
nnoremap <leader>fgs   <cmd>Telescope git_status<cr>
" Telescope Terraform
nnoremap <leader>ftf  <cmd>Telescope terraform_doc<cr>
nnoremap <leader>ftm  <cmd>Telescope terraform_doc modules<cr>
nnoremap <leader>ftfa <cmd>Telescope terraform_doc full_name=hashicorp/aws<cr>
nnoremap <leader>ftfk <cmd>Telescope terraform_doc full_name=hashicorp/kubernetes<cr>
" Telescope coc
nnoremap <leader>fca  <cmd>Telescope coc code_actions<cr>
nnoremap <leader>fcr  <cmd>Telescope coc references<cr>
nnoremap <leader>fcdi  <cmd>Telescope coc diagnostics<cr>
nnoremap <leader>fcde  <cmd>Telescope coc definitions<cr>
nnoremap <leader>fcds  <cmd>Telescope coc document_symbols<cr>
nnoremap <leader>fcws  <cmd>Telescope coc workspace_symbols<cr>

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

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.branch = ''
let g:airline_symbols.dirty=' '
let g:airline_symbols.linenr = '☰ '
let g:airline_symbols.maxlinenr = ''
let g:airline_left_sep=''
let g:airline_right_sep=''

let g:airline_detect_spell=0
let g:airline#extensions#coc#enabled = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline_theme = 'edge'
