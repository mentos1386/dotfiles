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
Plug 'sainnhe/edge'
Plug 'Yggdroot/indentLine'
Plug 'koenverburg/peepsight.nvim'
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
  \ 'coc-typos',
  \ 'coc-docker',
  \ 'coc-go',
  \ 'coc-html',
  \ 'coc-sql',
  \ 'coc-toml',
  \ 'coc-rust-analyzer',
  \ ]
if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
  let g:coc_global_extensions += ['coc-prettier']
endif
if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
  let g:coc_global_extensions += ['coc-eslint']
endif

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Diagnostic list
nnoremap <silent><nowait> <space>d :<C-u>CocList diagnostics<cr>
" Symbols list
nnoremap <silent><nowait> <space>s :<C-u>CocList -I symbols<cr>
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
    "terraform",
    "javascript",
    "json",
    "make",
    "markdown",
    "prisma",
    "proto",
    "rust",
    "typescript",
    "vim",
    "yaml",
    "glsl"
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
"--- Custom Configurations
augroup JsonToJsonc
    autocmd! FileType json set filetype=jsonc
augroup END

lua <<EOF
require'peepsight'.setup({
  -- typescript
  "arrow_function",
  "function_declaration",
  "generator_function_declaration",
  "method_definition",
})
require'peepsight'.enable()
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
"set spell spelllang=en_us
set updatetime=300
set cmdheight=2
set hidden
set shortmess+=c

"""""
"- Custom commands
command! -nargs=0 Prettier :CocCommand prettier.formatFile

"""""
"- Custom Filetypes
au BufRead,BufNewFile *.mdx setfiletype markdown

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
" Typos coc
" Move to next misspelled word after the cursor, 'wrapscan' applies.
nmap ]s <Plug>(coc-typos-next)
" Move to previous misspelled word after the cursor, 'wrapscan' applies.
nmap [s <Plug>(coc-typos-prev)
" Fix typo at cursor position
nmap z= <Plug>(coc-typos-fix)

"""""
"- Visuals
set noshowmode
set number
set cursorline
set hlsearch " highlight all results
set signcolumn=number " always show git diff column

"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif
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
let g:airline_symbols.maxlinenr = ' '
let g:airline_left_sep=''
let g:airline_right_sep=''

let g:airline_detect_spell=0
let g:airline#extensions#coc#enabled = 1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline_theme = 'edge'
