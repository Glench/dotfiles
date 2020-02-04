" Glench's vim configuration file

au CursorHold * checktime

" save my eyes
set background=dark

let macvim_skip_colorscheme=1
set guifont=Inconsolata:h15

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'


" Random vim niceties
" ===================


set nocompatible      " Explicitly get out of vi-compatible mode
set title             " Make terminal title file name
set ruler             " Show line numbers subtly.
set number            " Show line numbers
highlight LineNr ctermfg=darkgrey guifg=Grey
set showcmd           " Show (partial) command in status line.
" set showmatch         " Show matching brackets. Turned off because it makes
" typing > or < in JS in script tags beep.
set ignorecase        " Do case insensitive matching
set smartcase         " Do smart case matching
set incsearch         " Incremental search
set hlsearch          " Hilight the search terms
set cursorline        " Hilights the line the cursor's on
highlight CursorLine term=NONE cterm=NONE ctermbg=233 guibg=#121212
" highlight SignColumn ctermbg=black guibg=black " fix ugly sign col colors
set autoread          " auto-reload modified files with no local changes
set lazyredraw        " do not redraw while running macros
set mouse=a           " turn the mouse on for all modes
set laststatus=2      " make sure to always see the status line
set t_Co=256          " make sure colors work over ssh

" introduced in vim version 7.3
if version >= 703
  set relativenumber    " show line numbers in relation to current line
  au BufReadPost * set relativenumber " weird but useful

  highlight CursorLineNr ctermfg=206 guifg=#ff5fd7 " call out current line number

  " set colorcolumn=80 " Show where 80 characters is
  " highlight ColorColumn ctermbg=233 guibg=#121212
endif

" Indenting rules, mostly for python
set autoindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
" Default tab completion:
" imap <Tab> <C-P> " Don't use this since it autocompletes always in insert
" mode instead of inserting tabs which is really annoying.
" Show menu
set completeopt=menu,preview


set shiftround " when at a weird indent, reindent to correct place
set listchars=tab:>- " show tabs and trailing space
set invlist    " Show invisible chars, useful for finding tabs
" (XXX: #VIM/tpope warns the line below could break things)
set iskeyword+=$,@,%,# " none of these are word dividers
set scrolloff=4 " keep some lines at top/bottom for scope

" No sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" Keep swap files in one of these, double slash at the end prevents collisions
" for files named the same thing, apparently.
set directory=~/tmp//,/tmp//,.
set backupdir=~/tmp//,/tmp//,.
if version >= 703
    set undofile " also keep persistent undo when closing and reopening files
    set undodir=~/tmp//,/tmp//,.
endif


" Keyboard remapping
" ==================


" Remaps 'jj' in quick succession to <escape>
ino jj <esc>
cno jj <c-c>

" navigate by visual lines in text wrap situations
nmap <up> gk
nmap k gk
nmap <down> gj
nmap j gj

" in visual mode, use arrow keys or control+movement, navigating by visual
" line in text wrap situations
ino <C-h> <Left>
ino <C-j> <C-o>gj
ino <down> <C-o>gj
ino <C-k> <C-o>gk
ino <up> <C-o>gk
ino <C-l> <Right>

" Press Enter to turn off highlighting and clear any message already displayed.
nnoremap <silent> <Space> :call clearmatches()<CR>:nohlsearch<Bar>:echo<CR>

" Enter in normal mode creates an empty line underneath without moving the cursor
" noremap <CR> mlo<Esc>`l

" Remap tab to indent, backspace to unindent
nnoremap <BS> <<
nnoremap <tab> >>
vnoremap <BS> <gv
vnoremap <tab> >gv

" save session on buffer save and new buffer
function! s:save_session()
    execute "normal! :GSessionMakeLocall<cr>"
endfunction
autocmd BufWritePost <buffer> call s:save_session()
autocmd BufNew <buffer> call s:save_session()

" Fast saving and quitting, with automatic vim session saving
nmap <leader>w :w<cr>
vmap <leader>w :w<cr>
nmap <leader>wq :wq!<cr>
vmap <leader>wq :wq!<cr>
nmap <leader>q :q<cr>
vmap <leader>q :q<cr>
nmap <leader>a :qa<cr>
nmap <leader>1 :q!<cr>
nmap <leader>a1 :qa!<cr>

" When forgetting to sudo a file, use <Leader>! to save (or :w!!)
cnoremap w!! w !sudo tee % >/dev/null
nmap <Leader>! :w!!<cr>

" jump to previous cursor locations. Useful when searching text
nmap <leader><leader> <C-o>

" Bash like keys for the command line
cnoremap <C-A>      <Home>
cnoremap <C-E>      <End>


" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" convert tabs to spaces
noremap <Leader><Space> :%s/	/    /g<cr>

" toggle spelling with leader s
map <Leader>s :setlocal spell! spell?<CR>
" ]s and [s for finding misspelled words and z= for alternatives

" Y should yank to EOL
map Y y$

" make working with tabs cross-platform easier
map <Leader>t :tabnew<CR>
map <Leader>j :tabprevious<CR>
map <Leader>k :tabnext<CR>

" toggle pastemode
set pastetoggle=<Leader>p

" copy/cut/paste to system clipboard with Control + c/x/v, respectively
if has("unix")
    let s:uname = system("uname")
    " detect OSX (kind of a hack, but works)
    if s:uname == "Darwin\n"
        vnoremap <C-c> !pbcopy<CR>:undo<CR>
        " copy the current line but don't copy the indents in the line and keep cursor in same position
        nnoremap <C-c> mm^v$!pbcopy<CR>:undo<CR>`m
        vnoremap <C-x> !pbcopy<CR>
        inoremap <C-v> <Esc>:r!pbpaste<CR>a
        " note that this overwrites visual block selection
    else
        " if not OSX, just try to use the special system clipboard buffer
        vnoremap <C-c> "+y
        nnoremap <C-c> mm^v$"+y`m " copy current line
        vnoremap <C-x> "+d
        nnoremap <C-v> "+p
        inoremap <C-v> <Esc>"+pa
        " note that this overwrites visual block selection
    endif
endif

" Make better-named tabs
set guitablabel=%t

" Python macros too small to be used with snipmates
" noremap <leader>pd <Esc>iimport pdb; pdb.set_trace()<Esc>
" noremap <leader>pp <Esc>ifrom pprint import pprint<CR>pprint()<Esc>i
" noremap <leader>pl <Esc>iimport logging; logging.basicConfig(level=logging.DEBUG, format='%(asctime )s - %(levelname)s - %(message)s')<Esc>


" automatically install vim-plug plugin manager on new vim instance
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
    Plug 'tpope/vim-sensible'
    Plug 'Raimondi/delimitMate' " automatically close parens when typing, relies on vim-sensible for some reason
    Plug 'gorkunov/smartpairs.vim' " select between parens/quotes/brackets/etc with `vv`
    Plug 'vim-airline/vim-airline' " makes the vim statusbar pretty and useful
    Plug 'airblade/vim-gitgutter' " shows added/changed/removed lines in git
    Plug 'henrik/vim-indexed-search' " shows 'match 123 out of 456' when searching
    Plug 'tomtom/tcomment_vim' " allows commenting lines in visual and normal modes with //
    Plug 'danro/rename.vim' " rename a file you're working on with :rename[!] {newname}
    Plug 'terryma/vim-smooth-scroll' " smooth-scrolling
    Plug 'lifepillar/vim-solarized8' " nice theme
    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' } " tree explorer
    Plug 'godlygeek/tabular' " align lines
    Plug 'ryanpcmcquen/fix-vim-pasting' " detects when pasting and turns on paste mode
    Plug 'sheerun/vim-polyglot' " syntax highlighting for every language, run on demand for better startup time
    Plug 'luochen1990/rainbow' " unique coloring for nested parens and html tags
    Plug '/usr/local/opt/fzf' " installed via apt or homebrew
    Plug 'junegunn/fzf.vim' " very fast fuzzy file searching with <leader>e
    Plug 'ervandew/supertab' " add smart tab completion
    " Plug 'Glench/Vim-Jinja2-Syntax' " testing jinja support
call plug#end()
" profile with vim --startuptime ~/tmp/vim.log
" from https://kynan.github.io/blog/2015/07/31/how-to-speed-up-your-vim-startup-time

colorscheme solarized8

" tComment config, allow simple and smart commenting
nnoremap // :TComment<CR>
vnoremap // :TComment<CR>gv

" DelimitMate config, make enter key keep indent in function
let g:delimitMate_expand_cr = 1 " turn '(<cr>' into '(<cr>    |<cr>)'

" vim-smooth-scroll
noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>

" rainbow parens
let g:rainbow_active = 1

" nerdtree, open up automatically when opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" TODO: figure out how to use nerdtree with new tabs instead of buffers?
" TODO: how to have cursor in nerdtree by default when opening a directory
"
" moving between diffs from git and undoing them to match what's currently in git
nmap <leader>gj <Plug>(GitGutterNextHunk)
nmap <leader>gk <Plug>(GitGutterPrevHunk)
nmap <leader>gu <Plug>(GitGutterUndoHunk)
" nmap <Leader>hs <Plug>GitGutterStageHunk

" Align variable declarations (=), colon-separated dictionary items (:), and pipe-separated items (|)
nmap <Leader>= :Tabularize /=<CR>
vmap <Leader>= :Tabularize /=<CR>
nmap <Leader>: :Tabularize /:\zs<CR>
vmap <Leader>: :Tabularize /:\zs<CR>
nmap <Leader>: :Tabularize /\|<CR>
vmap <Leader>: :Tabularize /\|<CR>

" open new files with fuzzy searching
nmap <Leader>e :Files<CR>


" TODO: figure out correct copy/pasting, probably this: https://github.com/enricobacis/paste.vim
