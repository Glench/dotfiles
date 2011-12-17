" save my eyes
set background=dark

" Syntax highlighting
" ===================

syntax on
filetype plugin on
filetype indent on

" Figure out which type of hilighting to use for html.
" I use this to get nice jinja highlighting.
fun! s:SelectHTML()
let n = 1
while n < 50 && n < line("$")
  " check for jinja
  if getline(n) =~ '{%\s*\(extends\|block\|macro\|set\|if\|for\|include\|trans\)\>'
    set ft=jinja
    return
  endif
    let n = n + 1
  endwhile
  " go with html
  set ft=html
endfun
autocmd BufNewFile,BufRead *.html,*.htm  call s:SelectHTML()



" Random vim niceties
" ===================


set nocompatible " Explicitly get out of vi-compatible mode
set title        " Make terminal title file name
set ruler        " Show line numbers subtly.
set number       " Show line numbers
set showcmd      " Show (partial) command in status line.
set showmatch    " Show matching brackets.
set ignorecase   " Do case insensitive matching
set smartcase    " Do smart case matching
set incsearch    " Incremental search
set hlsearch     " Hilight the search terms
set cursorline   " Hilights the line the cursor's on
set autoread     " auto-reload modified files with no local changes
set lazyredraw   " do not redraw while running macros

" Indenting rules, mostly for python
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
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

" Bash like keys for the command line
cnoremap <C-A>      <Home>
cnoremap <C-E>      <End>
cnoremap <C-K>      <C-U>

" Remaps 'jj' in quick succession to <escape>
ino jj <esc>
cno jj <c-c>

" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Make better-named tabs in Macvim
set guitablabel=%t

" installing add-ons and their configuration
" ==========================================


" Awesome awesome awesome package manager for vim scripts
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

    call vam#ActivateAddons(["Command-T", "github:ervandew/supertab", "matchit.zip", "vim-less", "Jinja", "delimitMate", "The_NERD_Commenter"], {'auto_install' : 0})
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
set wildignore+=*.o,*.obj,.git,.svn,*.pyc,*.png,*.jpg,*.gif
noremap <leader>e :CommandT<cr>
noremap <leader>r :CommandTFlush<cr>
let g:CommandTMaxHeight = 15
let g:CommandTMaxFiles = 20000

" SuperTab, good tab completion
let g:SuperTabCrMapping = 0 " this is to not conflict with delimitMate

" matchit.zip, allows matching <> among other things
" vim-less, syntax highlighting for lesscss
" Jinja, syntax highlighting for Jinja2
" delimitMate, adds good matching of parens, brackets, quotes, etc
let g:delimitMate_expand_cr = 1 " turn '(<cr>' into '(<cr>    |<cr>)'
let g:delimitMate_expand_space = 1 " turn '( ' into '( | )'

" The NERD Commenter, use for smart commenting (usually use <leader>cu)
