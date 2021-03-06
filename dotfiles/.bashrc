# Glench's .bashrc
# This is the meat of my shell configuration.

# if not running interactively, do nothing
[ -z "$PS1" ] && return

HISTSIZE=1000000 # 1 million lines in history, why not?

# Useful Aliases
# ==============


# ls
export CLICOLOR=1 # helps ls show up with colors on Mac
alias ll='ls -alF'
alias la='ls -A'
alias cat='bat' # bat is a more friendly cat

if [[ $(uname) = 'Darwin' ]]; then
    alias ls='ls -p'
else
    alias ls='ls -p --color=always'
    alias grep='grep --color=always'
fi

# everything else
alias ..='cd ..' # up a directory
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'
alias -- -="cd -" # - to go back
alias code='cd ~/code/'
# narrow down ifconfig output to find roughly my ip
alias myip="ifconfig | grep -E '(192|10)'"

tmp() {
    if [[ -d ~/tmp ]]; then
        cd ~/tmp;
    else
        cd /tmp
    fi
}
mkdir_and_cd() {
    mkdir $1 && cd $1
}
diff_code() {
    if [[ -d .git ]]; then
        git diff | less
    elif [[ -d .svn ]]; then
        svn di | less
    else
        echo 'No code to diff here' 1>&2
    fi
}
update_code() {
    if [[ -d .git ]]; then
        git pull
    elif [[ -d .svn ]]; then
        svn up
    else
        echo 'No code to update here' 1>&2
    fi
}

extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

webserver() {
    python -m SimpleHTTPServer
}
alias mkcd='mkdir_and_cd'
alias up='update_code'
alias di='diff_code'
alias beep='echo -e "\a"; afplay /System/Library/Sounds/Glass.aiff;'

# mystery hunt stuff

# example usage: wp | wpcategory '.*films' | wptitle | egrep -i '\w+ does \w+$
#                ^ get all the titles of films in wikipedia and search for '<blank> does <blank>'

# wp         = list all entries in wikipedia file
# wpcategory = search for specific regex in the categories, e.g. 'wpcategory "films"'
# wptitle    = only show title in output, not categories
# wplink     = turn output into a link to wikipedia to click to see what a thing is

# alias wp="cat ~/wiki_title_categories.txt"
# alias wptitle="egrep -o '^.*:::' | egrep -o '^.*[^:::]'"
# alias wplink="sed -E 's/(.*)/\1                 https:\/\/en\.wikipedia\.org\/w\/index\.php\?title=Special:Search\&search=\1/' | sed -E 's/ /\+/g'"
# function wpcategory {
#     egrep -i ":::.*$1"
# }

# end mystery hunt stuff

fix_webcam() {
    sudo killall VDCAssistant
}

doit() {
    # get up and running with a web page really quickly
    id=$(uuid)j
    mkcd site && cp -r ~/dotfiles/bootstrap/* . && mvim . index.html
}
svelte_bootstrap() {
    npx degit Glench/template ${1:-svelte-app}
    cd ${1-svelte-app}
    npm install
    mvim .
    sleep 2 && open -a Firefox 'http://localhost:5000' &
    npm run dev
    echo -e '\n\n'
    echo 'to build optimized project: npm run build'
    echo 'to run dev server: npm run dev'
}

# virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/code
if [[ -e /usr/local/bin/virtualenvwrapper.sh ]]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi
if [[ -e /usr/share/virtualenvwrapper/virtualenvwrapper.sh ]]; then
    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
fi

# https://github.com/gokcehan/lf/blob/master/etc/lfcd.sh
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}
alias lf=lfcd

# install awesome fuzzy-finding with fzf, replace searching history / tab completion with **
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_COMMAND='fd --type f' # respect .gitignore so node_modules doesn't get searched

# Change UI
# =========


if [[ $(uname) = 'Darwin' ]]; then
    ############################################

    # Modified from emilis bash prompt script
    # from https://github.com/emilis/emilis-config/blob/master/.bash_ps1
    #
    # Modified for Mac OS X by
    # @corndogcomputer
    ###########################################
    # Fill with minuses
    # (this is recalculated every time the prompt is shown in function prompt_command):

    fill="--- "
    reset_style='\[\033[00m\]'
    status_style=$reset_style'\[\033[0;90m\]' # gray color; use 0;37m for lighter color
    prompt_style=$reset_style
    command_style=$reset_style'\[\033[1;29m\]' # bold black

    # Prompt variable:
    PS1="$status_style"'$fill \t\n'"$prompt_style"'${debian_chroot:+($debian_chroot)}\u@\h:\w\$'"$command_style "

    # Reset color for command output
    # (this one is invoked every time before a command is executed):
    trap 'echo -ne "\033[00m"' DEBUG

    function prompt_command {
    # create a $fill of all screen width minus the time string and a space:
        let fillsize=${COLUMNS}-9
        fill=""

        while [ "$fillsize" -gt "0" ]
            do
            fill="-${fill}" # fill with underscores to work on
            let fillsize=${fillsize}-1
        done

        # If this is an xterm set the title to user@host:dir
        case "$TERM" in
        xterm*|rxvt*)
        bname=`basename "${PWD/$HOME/~}"`
        echo -ne "\033]0;${bname}: ${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"
        ;;
        *)
        ;;
        esac
    }

    PROMPT_COMMAND=prompt_command
else
    # linux version
    # Fill with minuses
    # (this is recalculated every time the prompt is shown in function prompt_command):

    fill="--- "
    reset_style='\[\033[00m\]'
    status_style=$reset_style'\[\033[0;90m\]' # gray color; use 0;37m for lighter color
    prompt_style=$reset_style
    command_style=$reset_style'\[\033[1;29m\]' # bold black

    # Prompt variable:
    PS1="$status_style"'$fill \t\n'"$prompt_style"'${debian_chroot:+($debian_chroot)}\u@\h:\w\$'"$command_style "

    # Reset color for command output
    # (this one is invoked every time before a command is executed):
    trap 'echo -ne "\e[0m"' DEBUG
    function prompt_command {
        # create a $fill of all screen width minus the time string and a space:

        let fillsize=${COLUMNS}-9
        fill=""
        while [ "$fillsize" -gt "0" ]
            do
            fill="-${fill}" # fill with underscores to work on
            let fillsize=${fillsize}-1
        done

    # If this is an xterm set the title to user@host:dir
    case "$TERM" in
    xterm*|rxvt*)
    bname=`basename "${PWD/$HOME/~}"`
    echo -ne "\033]0;${bname}: ${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"

    ;;
    *)
    ;;
    esac
    }

    PROMPT_COMMAND=prompt_command
fi

