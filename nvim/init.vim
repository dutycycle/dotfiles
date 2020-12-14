set ttyfast
" Enable mouse use in all modes
set mouse=a

map ; :
nnoremap <SPACE> <Nop>
let mapleader=" "
nnoremap <Leader>ce :e $MYVIMRC<CR>
nnoremap <Leader>cr :source $MYVIMRC<CR>

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'https://github.com/alok/notational-fzf-vim'
let g:nv_search_paths = ['Dropbox/Notational\ Data']
nnoremap <Leader>n :NV<CR>
nnoremap <Leader>f :FZF ~/Developer<CR>

Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'jparise/vim-graphql'

Plug 'chriskempson/base16-vim'

Plug 'lambdalisue/fern.vim'
Plug 'antoinemadec/FixCursorHold.nvim'
let g:cursorhold_updatetime = 100



call plug#end()

colorscheme base16-ashes

