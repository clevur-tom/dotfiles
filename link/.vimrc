syntax enable

" Hacks to get colorschemes working in tmux
set bg=dark
set t_Co=256

" Next two blocks should always be before colorscheme entry
" Highlight EOL whitespace, http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace ctermbg=darkred guibg=#382424
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/

" The above flashes annoyingly while typing, be calmer in insert mode
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/

" <F3> turns Spacehi on/off.  Easily locate tabs.
autocmd syntax * SpaceHi

" Colorscheme and highlight all searches
colorscheme molokai
highlight Comment cterm=bold

" proper settings for tab spacing
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set softtabstop=4

" virtual block editing shit
set virtualedit=block
set clipboard+=unnamed  " Yanks go on clipboard instead.
set showmatch " Show matching braces.

" Line wrapping on by default
set wrap
set linebreak

set hlsearch " highlight all matches
set smartcase
set cursorline

set encoding=utf8
set fileencoding=utf8

set number ruler " show line numbers

" fix home / end problem
" For some reason home and end keys are not mapping properly.
" Home key
imap <esc>OH <esc>0i
cmap <esc>OH <home>
nmap <esc>OH 0
" End key
nmap <esc>OF $
imap <esc>OF <esc>$a
cmap <esc>OF <end>

" python syntax highlighting
let python_highlight_all = 1

" <F4> is used to turn on/off trailing whitespace
noremap <F4> :set list!<CR>
set listchars=eol:$,tab:>-,trail:.,extends:>,precedes:<,nbsp:_
