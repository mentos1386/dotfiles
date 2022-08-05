" Run PlugInstall if there are missing plugins
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

"""""
"--- Plugins
call plug#begin()

" General
Plug 'ojroques/vim-oscyank'
Plug 'tpope/vim-obsession'
Plug 'tmux-plugins/vim-tmux-focus-events'
" Look
Plug 'vim-airline/vim-airline'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
Plug 'Yggdroot/indentLine'
" Git
Plug 'airblade/vim-gitgutter'
" Search/Files
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'ANGkeith/telescope-terraform-doc.nvim'
Plug 'fannheyward/telescope-coc.nvim'
" Ignore/Edit files
Plug 'vim-scripts/gitignore'
" Coding helpers
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

"""""
"--- CodeServer Configurations
let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-prettier',
  \ 'coc-yaml',
  \ 'coc-json',
  \ 'coc-git',
  \ 'coc-pyright',
  \ 'coc-pairs',
  \ 'coc-prisma',
  \ 'coc-sh',
  \ ]
if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif
if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

" Diagnostic list
nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>
" Symbols list
nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
" Code actions
nmap <leader>do <Plug>(coc-codeaction)
" Rename current world
nmap <leader>rn <Plug>(coc-rename)
" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

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
    autocmd!
    autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankReg "' | endif
  augroup END
endif

""""
"--- Treesitter configuration
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "python",
    "bash",
    "dockerfile",
    "go",
    "graphql",
    "hcl",
    "javascript",
    "json",
    "make",
    "markdown",
    "prisma",
    "proto",
    "rust",
    "typescript",
    "vim",
    "yaml"
  },
  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,
  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    -- list of language that will be disabled
    disable = { "" },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  indent = {
    -- dont enable this, messes up python indentation
    enable = false,
    disable = {},
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
require'telescope'.load_extension('coc')
EOF

"""""
"--- VIM Configuration
set encoding=UTF-8
set autoread " will re-read opened file if changed externaly
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
set spell spelllang=en_us
set updatetime=300
set cmdheight=2
set hidden
set shortmess+=c

"""""
"- Custom commands
command! -nargs=0 Prettier :CocCommand prettier.formatFile

"""""
"- Keybindings
" Using SPACE as <leader> key
nnoremap <SPACE> <Nop>
let mapleader = " "

" Telescope
nnoremap <c-p>        <cmd>Telescope find_files<cr>
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
set noshowmode
set number
set cursorline
set hlsearch " highlight all results
set signcolumn=number " always show git diff column
colorscheme onehalflight

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.branch = ''
let g:airline_symbols.dirty=' '
let g:airline_symbols.linenr = '☰ '
let g:airline_symbols.maxlinenr = ' '
let g:airline_left_sep=''
let g:airline_right_sep=''

let g:airline_detect_spell=0
let g:airline#extensions#coc#enabled = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline_theme = 'onehalflight'
