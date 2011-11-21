# Glench's .profile
export EDITOR="vim"
# work-specific .profile that I can't share
if [[ -f ~/.om_profile ]]; then
    source ~/.om_profile
fi


# Useful Aliases
# ==============


# ls
alias ll='ls -alF'
alias la='ls -A'
if [[ $(uname) = 'Darwin' ]]; then
    alias ls='ls -p'
else
    alias ls='ls -p --color=always'
    alias grep='grep --color=always'
fi

# everything else
alias ..='cd ..'
# narrow down ifconfig output to find roughly my ip
alias myip="ifconfig | grep -E '(192|10)'" 
alias irc="ssh glench@staticfree.info"
alias di="svn di | less"
alias untar="tar -zxvf"

update_code() {
    if [[ -d .git ]]; then
        git pull
    elif [[ -d .svn ]]; then
        svn up
    else
        echo 'No code to update here' 1>&2
    fi
}
alias up='update_code'

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
