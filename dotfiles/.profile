# Glench's .profile
# After a long time of trying to figure it out, I found that putting all
# my stuff in .bashrc and sourcing that from .profile is the optimal thing to
# do across all platforms

export EDITOR="vim"
export PAGER="less"
export PYTHONSTARTUP=~/.pythonrc.py
export LSCOLORS=GxFxCxDxBxegedabagaced

if [[ -f ~/.bashrc ]]; then
    source ~/.bashrc
fi
