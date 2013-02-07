# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/keisuke-zsh/.zsh/.zshrc'

autoload -Uz compinit
compinit
zstyle ':completion:*' format '%BCompleting %d%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' menu select
# End of lines added by compinstall

autoload colors
colors

# export PROMPT='%F{red}%K{white}%B%n {%~} %%%k %b%f'
nprom () {
    PROMPT=%(?|%F{red}|%18(?|%F{red}|%F{yellow}))"%B%n%f:%F{green}%~%f%F{red}%%%b%f "
    }
nprom

setopt hist_ignorespace
setopt hist_ignore_dups
setopt hist_no_store
setopt extended_history hist_save_nodups
# setopt inc_append_history
# setopt share_history

# use emacs
# export EDITOR='emacsclient -t'
# export VISUAL='emacsclient -t'
export EDITOR='emacsclient -nw'
export VISUAL='emacsclient -nw'

# aliases
alias fg=' fg' bg=' bg' exit=' exit'
# alias e='emacs'
alias e=' em-w'
# alias e-nw=' emacsclient -n'
# alias e-t=' emacsclient -t'
alias t=' tmux' ta=' t a' tls=' t ls'
alias cte='crontab -e'

alias rm='rm -i' cp='cp -i' mv='mv -i'
alias copy='cp -ip' del='rm -i' move='mv -i'
h () {history $* | less}
alias h=' h'
alias ls=' ls -hF --color=auto'
alias ll=' ls -l' la=' ls -A' l=' ls -CF'

setopt auto_cd
setopt auto_pushd

chpwd() {
    ls_abbrev
}
ls_abbrev() {
    # -a : Do not ignore entries starting with ..
    # -C : Force multi-column output.
    # -F : Append indicator (one of */=>@|) to entries.
    local cmd_ls='ls'
    local -a opt_ls
    opt_ls=('-aCF' '--color=always')
    case "${OSTYPE}" in
        freebsd*|darwin*)
            if type gls > /dev/null 2>&1; then
                cmd_ls='gls'
            else
                # -G : Enable colorized output.
                opt_ls=('-aCFG')
            fi
            ;;
    esac

    local ls_result
    ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

    local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

    if [ $ls_lines -gt 10 ]; then
        echo "$ls_result" | head -n 5
        echo '...'
        echo "$ls_result" | tail -n 5
        echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
    else
        echo "$ls_result"
    fi
}

alias pu=pushd po=popd dirs='dirs -v'
alias grep='grep --color'

## cdr system stuff.
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# zaw
source ~/.zsh/zaw/zaw.zsh
bindkey '^z' zaw-cdr

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

# Attache tmux (from http://transitive.info/2011/05/01/tmux/)
if ( ! test $TMUX ) && ( ! expr $TERM : "^screen" > /dev/null ) && which tmux > /dev/null; then
    if ( tmux has-session ); then
	session=`tmux list-sessions | grep -e '^[0-9].*]$' | head -n 1 | sed -e 's/^\([0-9]\+\).*$/\1/'`
	if [ -n "$session" ]; then
	        echo "Attache tmux session $session."
		    tmux attach-session -t $session
		    else
	        echo "Session has been already attached."
		    tmux list-sessions
		    fi
    else
	echo "Create new tmux session."
	tmux
    fi
fi
