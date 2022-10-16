set noswapfile
set ttyfast
" Enable mouse use in all modes
set mouse=a
set wrap
set linebreak
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

autocmd FileType solidity setlocal shiftwidth=4 softtabstop=4 expandtab
autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 expandtab


map ; :
nnoremap <SPACE> <Nop>
let mapleader=" "

" config file: edit, reload, install plugins
nnoremap <Leader>ce :e $MYVIMRC<CR>
nnoremap <Leader>cr :source $MYVIMRC<CR>
nnoremap <Leader>cp :PlugInstall<CR> 

nnoremap q :quit<CR>

call plug#begin('~/.vim/plugged')

" notational velocity
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'alok/notational-fzf-vim'
let g:nv_search_paths = ["~/Desktop/world"]
nnoremap <Leader>n :NV<CR>


nnoremap <Leader>fd :FZF ~/Developer<CR>
nnoremap <Leader>fh :FZF ~<CR>
nnoremap <Leader>fa :FZF /<CR>
nnoremap <Leader>ff :FZF<CR>

" appearance
Plug 'junegunn/goyo.vim'
nnoremap <Leader>gy :Goyo<CR>

Plug 'chriskempson/base16-vim'

" navigation
Plug 'christoomey/vim-tmux-navigator'

" git stuff
Plug 'nvim-lua/plenary.nvim'
Plug 'TimUntersberger/neogit'
nnoremap <Leader>gg :Neogit<CR>
nnoremap <Leader>gc :Neogit commit<CR>

Plug 'preservim/nerdtree'
let NERDTreeShowHidden=1
nnoremap <Leader>ft :NERDTree<CR>

" LSP Support
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

" Autocompletion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'

"  Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'

Plug 'VonHeikemen/lsp-zero.nvim'

Plug 'bluz71/vim-moonfly-colors'

call plug#end()

lua <<EOF
local lsp = require('lsp-zero')
lsp.preset('recommended')
lsp.setup()
EOF

colorscheme moonfly

