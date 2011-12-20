" Glench's vim configuration file

" save my eyes
set background=dark

" Syntax highlighting
" ===================

syntax on
filetype plugin on
filetype indent on


" Random vim niceties
" ===================


set nocompatible      " Explicitly get out of vi-compatible mode
set title             " Make terminal title file name
set clipboard=unnamed " yank/paste from system clipboard in macvim
set ruler             " Show line numbers subtly.
set number            " Show line numbers
set showcmd           " Show (partial) command in status line.
set showmatch         " Show matching brackets.
set ignorecase        " Do case insensitive matching
set smartcase         " Do smart case matching
set incsearch         " Incremental search
set hlsearch          " Hilight the search terms
set cursorline        " Hilights the line the cursor's on
set autoread          " auto-reload modified files with no local changes
set lazyredraw        " do not redraw while running macros
" introduced in vim version 7.3
if version >= 703
  set relativenumber    " show line numbers in relation to current line
  au BufReadPost * set relativenumber " weird but useful
endif


" Indenting rules, mostly for python
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set shiftround " when at a weird indent, reindent to correct place
set listchars=tab:>-,trail:- " show tabs and trailing space
set invlist    " Show invisible chars, useful for finding tabs
" (XXX: #VIM/tpope warns the line below could break things)
set iskeyword+=$,@,%,# " none of these are word dividers

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

" Keep swap files in one of these
set directory=~/tmp,/tmp,.


" Keyboard remapping
" ==================


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

" Press space to turn off highlighting and clear any message already displayed.
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" keep some lines at top/bottom for scope
set scrolloff=7

" Enter in normal mode creates an empty line underneath without moving the cursor
noremap <CR> mlo<Esc>`l

" Remap tab to indent, backspace to unindent
nnoremap <BS> <<
nnoremap <tab> >>
vnoremap <BS> <
vnoremap <tab> >

" Fast saving and quitting
nmap <leader>w :w<cr>
nmap <leader>wq :wq!<cr>
nmap <leader>q :q<cr>
nmap <leader>1 :q!<cr>

" When forgetting to sudo a file, use <Leader>! to save (or :w!!)
cnoremap w!! w !sudo tee % >/dev/null
nmap <Leader>! :w!!<cr>

" Bash like keys for the command line
cnoremap <C-A>      <Home>
cnoremap <C-E>      <End>
cnoremap <C-K>      <C-U>

" Remaps 'jj' in quick succession to <escape>
ino jj <esc>
cno jj <c-c>

" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" toggle spelling with leader s
map <Leader>s :setlocal spell! spell?<CR>
" ]s and [s for finding misspelled words and z= for alternatives

" Make better-named tabs in Macvim
set guitablabel=%t


" Installing add-ons and their configurations
" ===========================================


" Awesome awesome awesome package manager for vim scripts
" Operative commands are :UninstallNotLoadedAddons and :UpdateAddons
fun SetupVAM()
    " YES, you can customize this vam_install_path path and everything still works!
    let vam_install_path = expand('$HOME') . '/.vim/vim-addons'
    exec 'set runtimepath+='.vam_install_path.'/vim-addon-manager'

    " * unix based os users may want to use this code checking out VAM
    " * windows users want to use http://mawercer.de/~marc/vam/index.php
    "   to fetch VAM, VAM-known-repositories and the listed plugins
    "   without having to install curl, unzip, git tool chain first
    if !isdirectory(vam_install_path.'/vim-addon-manager') && 1 == confirm("git clone VAM into ".vam_install_path."?","&Y\n&N")
        " I'm sorry having to add this reminder. Eventually it'll pay off.
        call confirm("Remind yourself that most plugins ship with documentation (README*, doc/*.txt). Its your first source of knowledge. If you can't find the info you're looking for in reasonable time ask maintainers to improve documentation")
        exec '!p='.shellescape(vam_install_path).'; mkdir -p "$p" && cd "$p" && git clone --depth 1 git://github.com/MarcWeber/vim-addon-manager.git'
    endif

    call vam#ActivateAddons(["Command-T", "github:ervandew/supertab", "matchit.zip", "vim-less", "delimitMate", "surround", "Indent_Guides", "jQuery", "tComment", "IndexedSearch", "github:Glench/Vim-Jinja2-Syntax"], {'auto_install' : 0})
    " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})
    " where pluginA could be github:YourName or snipmate-snippets see vam#install#RewriteName()
    " also see section "5. Installing plugins" in VAM's documentation
    " which will tell you how to find the plugin names of a plugin
endf
call SetupVAM()
    " experimental: run after gui has been started (gvim) [3]
    " option1:  au VimEnter * call SetupVAM()
    " option2:  au GUIEnter * call SetupVAM()
    " See BUGS sections below [*]

" Command-T, quickly find and open file
    " https://github.com/wincent/Command-T
    set wildignore+=*.o,*.obj,.git,.svn,*.pyc,*.png,*.jpg,*.gif
    noremap <leader>e :CommandT<cr>
    noremap <leader>r :CommandTFlush<cr>
    let g:CommandTMaxHeight = 15
    let g:CommandTMaxFiles = 20000 " need to see all files in directory

" SuperTab, good tab completion
    " https://github.com/ervandew/supertab
    let g:SuperTabCrMapping = 0 " this is to not conflict with delimitMate

" matchit.zip, allows matching <> among other things
    " http://www.vim.org/scripts/script.php?script_id=39

" vim-less, syntax highlighting for lesscss
    " https://github.com/groenewege/vim-less

" delimitMate, adds good matching of parens, brackets, quotes, etc
    " https://github.com/Raimondi/delimitMate
    let g:delimitMate_expand_cr = 1 " turn '(<cr>' into '(<cr>    |<cr>)'
    let g:delimitMate_expand_space = 1 " turn '( ' into '( | )'

" surround, change surround brackets, quotes, html tags, etc.
    " https://github.com/tpope/vim-surround
    " use ds<char> and cs<old><new>
    " use dst/cst for html

" Indent_Guides, visually show indents
    " https://github.com/nathanaelkane/vim-indent-guides
    let g:indent_guides_guide_size = 1
    let g:indent_guides_color_change_percent = 7
    let g:indent_guides_enable_on_vim_startup = 0

" jQuery, add better syntax highlighting
    " https://github.com/itspriddle/vim-jquery
    autocmd BufRead,BufNewFile *.js set ft=javascript syntax=jquery " set on all js

" tComment, allow simple and smart commenting
    " https://github.com/tomtom/tcomment_vim
    nnoremap // :TComment<CR>
    vnoremap // :TComment<CR>

" IndexedSearch, add '<count> of <total>' when doing text searches
    " https://github.com/vim-scripts/IndexedSearch

" Vim-Jinja2-Syntax, syntax highlighting for Jinja2
    " https://github.com/Glench/Vim-Jinja2-Syntax

