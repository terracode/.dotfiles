#----------------------------------------------------------------------------#
# Base variables
#----------------------------------------------------------------------------#
export EDITOR='subl -w'

BASE_PATH=/usr/bin:/bin:/usr/sbin:/sbin
BREW_PATH=/usr/local/bin:/usr/local/sbin
COREUTILS_PATH=/usr/local/opt/coreutils/libexec/gnubin
export PATH=$BREW_PATH:$COREUTILS_PATH:$BASE_PATH

COREUTILS_MANPATH=/usr/local/opt/coreutils/libexec/gnuman
export MANPATH=COREUTILS_MANPATH:$MANPATH
export PAGER=most
export SHELL=/bin/zsh

# root cursor brackets
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main pattern)
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')

# setup history
setopt HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS
setopt histexpiredupsfirst histfindnodups
setopt histignoredups histnostore histverify histignorespace extended_history share_history

# search in history
autoload -U predict-on
zle -N predict-on
zle -N predict-off
bindkey "^X^Z" predict-on # C-x C-z
bindkey "^Z" predict-off # C-z

# normalize mac os delete-key
# bindkey '^[[3~' delete-char 
# auto-substitution full path to command
bindkey '^E' expand-cmd-path

# path to syntax highlights file
# export $DIRCOLORS_FILE = $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting/dir_colors

# reload dynamically a new commands
# _force_rehash() { (( CURRENT == 1 )) && rehash return 1 }
# zstyle ':completion:::::' completer _force_rehash _complete

# other's stuff
typeset -U path cdpath fpath manpath
setopt   notify globdots correct pushdtohome cdablevars autolist
setopt   correctall autocd recexact longlistjobs
setopt   autoresume histignoredups pushdsilent noclobber
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash

#----------------------------------------------------------------------------#
# Extra packages
#----------------------------------------------------------------------------#
# source `brew --prefix`/etc/grc.bashrc

#----------------------------------------------------------------------------#
# Base aliases
#----------------------------------------------------------------------------#

# lists
# alias l='ls -CF'
# alias la='ls -AL'
# alias ll='ls -lF'
# alias lla='ls -lsa'

# move-rename w/o correction and always in interactive mode
alias mv='nocorrect mv -i'
# recursize copy w/o correction and always in interactive mode
alias cp='nocorrect cp -iR'
# remove w/o correction and always in interactive mode
alias rm='nocorrect rm -i'
# create direcotory w/o correction
alias mkdir='nocorrect mkdir'

alias ps='ps aux'
# more
alias scat=$PAGER

alias df='df -h' 
alias du='du -sh'
alias grep='egrep --color=auto'
alias ports='lsof -i -P -a | grep -i "listen" | _cut_lsof | sort'
alias mkpass='head -c6 /dev/urandom | xxd -ps'
alias -s {py}='python'
# alias -s txt=$PAGER

alias logc="grc cat"
alias logt="grc tail"
alias logh="grc head"

#----------------------------------------------------------------------------#
# Some small utilities
#----------------------------------------------------------------------------#
# ...for "ports" alias
_cut_lsof () {
	awk '{printf "%-15s %-5s %-3s %-20s\n", $1, $2, $3, $9}'
}

#----------------------------------------------------------------------------#
# Base shortcuts
#----------------------------------------------------------------------------#
#edit
#'open -a "Sublime Text"'
# alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'

#----------------------------------------------------------------------------#
# Launch shortcuts
#----------------------------------------------------------------------------#
_stop_process () {
	sudo launchctl stop $1
    # sudo kill -9 `\ps -A | grep nginx | grep -v grep | awk '{print $1}'`
	sudo killall $1
}

_restart_process () {
	_stop_process $1
	sudo launchctl start $1
}

#----------------------------------------------------------------------------#
# Extends autocomplete
#----------------------------------------------------------------------------#
zstyle ':completion:*:processes-names' command 'ps -e -o comm='
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*'   force-list always
zstyle ':completion:*:*:kill:*' menu yes select

# complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh
# ssh-keygen -l -f ~/.ssh/known_hosts
if [ -e $HOME/.ssh/known_hosts ] ; then 
    # hosts+=(${${${(f)"$(<$HOME/.ssh/known_hosts)"}%%\ *}%%,*}) 
    zstyle ':completion:*:hosts' hosts $hosts 
fi

#----------------------------------------------------------------------------#
# Extends functions
#----------------------------------------------------------------------------#
# check is application exists via 'which' utility
function provided_in_env()
{
    local bin=$1

    if which $bin > /dev/null 2>&1; then
    return 0
    fi

    return 1
}

function pack() {
    # www.christoph-polcin.com
    if [[ $# -lt 2 ]]; then
        echo "usage:  pack archive.extension [dir|file]+"
        return 1
    fi

    [[ -f $1 ]] && echo "error: destination $1 already exists." && return 1

    local lower
    lower=${(L)1}
    case $lower in
        *.tar.bz2) tar cvjf $@;;
        *.tar.gz) tar cvzf $@;;
        *.tar.xz) tar cvJf $@;;
        *.tar.lzma) tar --lzma -cvf $@;;
        *.bz2) 7za a -tbzip2 $@;;
        *.gz) 7za a -tgzip $@;;
        *.tar) tar cvf $@;;
        *.tbz2) tar cvjf $@;;
        *.tgz) tar cvzf $@;;
        *.zip) zip -r $@;;
        *.7z) 7za a -t7z -mmt $@;;
        *) echo "'$1' unsupported archive format / extension.";;
    esac
}

# function bftp () {
#     echo open $1; 
#     # echo user $2; 
#     cat $2 | awk '{ print "put " $1; }'; 
#     echo bye
# }

source ~/.rvm/scripts/rvm