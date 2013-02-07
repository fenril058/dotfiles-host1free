limit coredumpsize 0
# Setup command search path
typeset -U path cdpath fpath manpath
path=(/usr/local/*/bin(N-/) /usr/*/bin /var/*/bin(N-/) ~/*/bin(N-/) $PATH)
export PATH=$PATH
export LANG=ja_JP.UTF-8
# export LC_CTYPE=ja_JP.UTF-8@cjknarrow

export RSYNC_RSH=ssh
export CVS_RSH=ssh

export ZDOTDIR=$HOME/.zsh



