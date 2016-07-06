# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
ZSH_THEME="mk"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	zsh-syntax-highlighting
	# zsh-syntax-highlighting-filetypes
	osx autojump copyfile copydir rsync cp history extract
    rake bundler rvm gem tugboat
	docker docker-compose docker-machine
    brew sublime
	git github git-flow
	mk
)

# User configuration

export PATH="./.bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# todo: move all to .dotfiles & source it

hash -d zsh=~/.oh-my-zsh
hash -d w=~/Workspace/

#----------------------------------------------------------------------------#
# Base aliases
#----------------------------------------------------------------------------#

# lists
# alias l='ls -CF'
# alias la='ls -AL'
# alias ll='ls -lF'
# alias lla='ls -lsa'

alias ls='ls -Glsah --color=auto --group-directories-first'

alias zsh!='. ~/.zshrc'

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

alias g='git'
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

# -bool
alias show_hidden="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder"
alias hide_hidden="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder"

function mem() {
    ps -eo size,pid,user,command --sort -size | awk '{ hr=$1/1024 ; printf("%13.2f Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }'
}

alias dm="docker-machine"
alias dc="docker-compose"
alias dc.rm="dc stop && dc rm -f"
alias d="docker"
alias d.run="docker run -it"
alias d.rm="docker ps -a --no-trunc | grep 'Exit' | awk '{print $1}' | xargs docker rm"
alias d.rmv="d volume ls -qf dangling=true | xargs -r d volume rm"

alias tb="tugboat"

function d.rmi() {
    docker rmi $(docker images | grep "^<none>" | awk '{print $3}')
}

function d.build() {
    d build -t $1 .
}

function d.push() {
    dbuild $1
    d push $1
}

# function drun!() {
#     docker run -it --rm \
#         -w /host \
#         -v $PWD:/host \
#         -v ~/.boot2docker:/root/.boot2docker \
#         -v ~/.docker:/root/.docker \
#         -e DOCKER_CERT_PATH=~/.boot2docker/certs/boot2docker-vm \
#         -e DOCKER_HOST=$DOCKER_HOST \
#         -e DOCKER_TLS_VERIFY=$DOCKER_TLS_VERIFY \
#         -e DOCKER_REMOTE_CERT_PATH=~/.docker \
#         -e DOCKER_REMOTE_TLS_VERIFY=$DOCKER_REMOTE_TLS_VERIFY \
#         $*
# }

function d.dump() {
    docker run --rm --volumes-from $1 -v $(pwd):/backup busybox tar cvf /backup/backup.tar $2
}

# see:
# https://github.com/emcrisostomo/fswatch
# http://habrahabr.ru/post/240277/
#
function dwatch () {
    app_path=$PWD/$1
    # echo "Starting fswatch on $app_path"

    # tracking previous not to get into endless loop of changing the same file
    local previous=''
    local LOOPCOUNT=0
    
    # \.git|
    # -e "___jb_(bak|old)___$"

    fswatch -L $app_path | while read file; do  # -o
        # echo "changed: $file"
        if [[ $file =~ "."___jb_(bak|old)___$ || $file =~ "."(idea|git) ]]; then
            continue
        fi

        if [[ $3 != "" && $file =~ $3 ]]; then
            continue
        fi

        if [[ previous != "$file" ]]; then
            is_even=$( expr $LOOPCOUNT % 2 )
            ((LOOPCOUNT++))

            if [ $is_even -ne 0 ]
            then
                continue
            fi

            echo "${file/$PWD\//""}"
            docker exec -d $2 sh -c "touch ${file/$PWD\//""}"
        fi

        previous="$file"
    done
}

# export GOPATH=$HOME/.go
export GOPATH=$HOME/Workspace/go
export PATH=$PATH:$GOPATH/bin
export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"

# see in boot2docker-vm: /var/lib/boot2docker/tls/hostnames
# export DOCKER_HOST=tcp://192.168.59.103:2376
#export DOCKER_HOST=tcp://boot2docker:2376
#export DOCKER_CERT_PATH=/Users/stereomisha/.boot2docker/certs/boot2docker-vm
#export DOCKER_TLS_VERIFY=1

#export DOCKER_REMOTE_CERT_PATH=~/.docker
#export DOCKER_REMOTE_TLS_VERIFY=1

#export TUTUM_USER="stereomisha"

export DO_TOKEN=cd4cc2fe00b5bcae94d0b4fbf131a7540bb38b815686ce514ce6880d9adbb258
