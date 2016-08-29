
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile


" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Show line numbers in gutter
set number
set numberwidth=2
highlight LineNr term=bold cterm=NONE ctermfg=Brown ctermbg=NONE gui=NONE guifg=Grey guibg=NONE

" Add a bit extra margin to the left
set foldcolumn=1

" Show matching brackets when text indicator is over them
set showmatch 

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=2
set tabstop=2

" Linebreak on 500 characters
set lbr
set tw=500

set cindent
set cinkeys-=0#
set indentkeys-=0#
set wrap "Wrap lines

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <c-space> ?



