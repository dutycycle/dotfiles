set noswapfile
set ttyfast
" Enable mouse use in all modes
set mouse=a

map ; :
nnoremap <SPACE> <Nop>
let mapleader=" "
nnoremap <Leader>ce :e $MYVIMRC<CR>
nnoremap <Leader>cr :source $MYVIMRC<CR>


call plug#begin('~/.vim/plugged')

" notational velocity
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'https://github.com/alok/notational-fzf-vim'
let g:nv_search_paths = ['Desktop/world']
nnoremap <Leader>n :NV<CR>
nnoremap <Leader>f :FZF ~/Developer<CR>

" appearance
Plug 'junegunn/goyo.vim'
nnoremap <Leader>w :Goyo<CR>

Plug 'chriskempson/base16-vim'

" file manager
Plug 'lambdalisue/fern.vim'
Plug 'antoinemadec/FixCursorHold.nvim'
let g:cursorhold_updatetime = 100
set fillchars+=vert:│
hi VertSplit ctermbg=NONE guibg=NONE

" navigation
Plug 'christoomey/vim-tmux-navigator'

" git stuff
Plug 'nvim-lua/plenary.nvim'
Plug 'TimUntersberger/neogit'
nnoremap <Leader>gg :Neogit<CR>
nnoremap <Leader>gc :Neogit commit<CR>

call plug#end()

colorscheme base16-ashes


