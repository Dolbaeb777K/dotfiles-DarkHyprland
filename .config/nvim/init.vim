
:set mouse
:set number
" :set relativenumber
:set smarttab
:set tabstop=2
:set shiftwidth=2
:set softtabstop=2
:set autoindent

" Убирает перенос текста на строку ниже. Отображение: "Мягкая переноска"...
:set nowrap


" Binds.
" --- Nerd Tree...
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>


call plug#begin()

" Beaty line..
Plug 'https://github.com/vim-airline/vim-airline'

" The Tree of files.
Plug 'https://github.com/preservim/nerdtree'

" Glyphs
Plug 'https://github.com/ryanoasis/vim-devicons'

"	Transparent
Plug 'xiyaowong/transparent.nvim'

"


call plug#end()
