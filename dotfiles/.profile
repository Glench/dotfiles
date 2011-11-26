# Glench's .profile
# After a long time of trying to figure it out, I found that putting all
# my stuff in .bashrc and sourcing that from .profile is the optimal thing to
# do across all platforms

export EDITOR="vim"
export PYTHONSTARTUP=~/.pythonrc.py
# work-specific .profile that I can't share
if [[ -f ~/.om_profile ]]; then
    source ~/.om_profile
fi
if [[ -f ~/.bashrc ]]; then
    source ~/.bashrc
fi
