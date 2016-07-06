# https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/steeef.zsh-theme
# https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/sorin.zsh-theme

# prompt style and colors based on Steve Losh's Prose theme:
# http://github.com/sjl/oh-my-zsh/blob/master/themes/prose.zsh-theme
#
# vcs_info modifications from Bart Trojanowski's zsh prompt:
# http://www.jukie.net/bart/blog/pimping-out-zsh-prompt
#
# git untracked files modification from Brian Carper:
# http://briancarper.net/blog/570/git-info-in-your-zsh-prompt

#----------------------------------------------------------------------------#
# Colors
#----------------------------------------------------------------------------#
# export TERM=xterm-color
export CLICOLOR=1

local dircolors_bin=""
for itr in 'dircolors' 'gdircolors'
do
    if (provided_in_env $itr); then
        dircolors_bin=$itr
        break
    fi
done
if [[ "$dircolors_bin" != "" ]]; then
    eval $(dircolors -b $ZSH/plugins/zsh-syntax-highlighting/.ls_colors)
fi

pallete () {
    for i in {0..255}; do echo -e "\e[38;05;${i}m${i}"; done | column -c 80 -s ' '; echo -e "\e[m"
}

# LS_COLORS="di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32";
# LSCOLORS="ExGxFxDxCxDxDxhbhdacEc";
# export LSCOLORS="Gxfxcxdxbxegedabagacad"
# export LS_COLORS='no=00:fi=00:di=01;34:ln=00;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=41;33;01:ex=00;32:*.cmd=00;32:*.exe=01;32:*.com=01;32:*.bat=01;32:*.btm=01;32:*.dll=01;32:*.tar=00;31:*.tbz=00;31:*.tgz=00;31:*.rpm=00;31:*.deb=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.zoo=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.tb2=00;31:*.tz2=00;31:*.tbz2=00;31:*.avi=01;35:*.bmp=01;35:*.fli=01;35:*.gif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mng=01;35:*.mov=01;35:*.mpg=01;35:*.pcx=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.xbm=01;35:*.xpm=01;35:*.dl=01;35:*.gl=01;35:*.wmv=01;35:*.aiff=00;32:*.au=00;32:*.mid=00;32:*.mp3=00;32:*.ogg=00;32:*.voc=00;32:*.wav=00;32:'

# Do we need Linux or BSD Style?
if ls --color -d . &>/dev/null 2>&1
then
  # Linux Style
  export LS_COLORS=$LS_COLORS
  # alias ls='ls --color=tty'
else
  # BSD Style
  export LSCOLORS=$LSCOLORS
fi

# Use same colors for autocompletion
zmodload -a colors
zmodload -a autocomplete
zmodload -a complist
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Allow for functions in the prompt.
# setopt PROMPT_SUBST
# Promt settings
# PROMPT='%F{yellow}%n@%m%f:%F{cyan}%~%F{magenta}$(__git_ps1 "(%s)")%F{green}$%f '

setopt prompt_subst
# autoload colors
autoload -U colors
colors

#use extended color pallete if available
# if [[ $TERM = *256color* || $TERM = *rxvt* ]]; then
lightgray="%F{250}"
gray="%F{239}"
orange="$FG[214]"
darkorange="%F{166}"  # $fg[yellow]
purple="%F{135}"  # $fg[magenta]
hotpink="%F{161}"  # $fg[red]
green="%F{040}"
limegreen="%F{118}"  # $fg[green]
yellow="%F{226}"
darkyellow="$FG[178]"
turquoise="%F{81}"  # $fg[cyan]
limeblue="%F{033}"
llimeblue="%F{039}"
lightblue="$FG[075]"
llightblue="$FG[117]"
darkblue="$FG[032]"
# grey='\e[0;90m'

# Git
ZSH_THEME_GIT_PROMPT_ADDED="%{$green%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$green%}*"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}-"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$orange%}*"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$terminfo[bold]$yellow%}#"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$lightgray%}."
ZSH_THEME_GIT_PROMPT_STASHED="%{$yellow%}^"
ZSH_THEME_GIT_PROMPT_AHEAD=""  # |, !, %
ZSH_THEME_GIT_PROMPT_BEHIND=""
ZSH_THEME_GIT_PROMPT_DIVERGED=""
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[magenta]%}: %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

function git_prompt {
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo " %{$fg[magenta]%}[$(git_prompt_info)$(git_prompt_status)%{$fg[magenta]%}]%{$reset_color%}"
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo ' ('`basename $VIRTUAL_ENV`')'
}

function rvm_prompt {
  local info="$(rvm_prompt_info || rbenv_prompt_info)"
  [ $info ] && echo " %{$fg_bold[red]%}$info%{$reset_color%}"
}

local pwd='%{$llightblue%}%~%{$reset_color%}'
local pointer=' %{$lightgray%}$%{$reset_color%} '
local git='$(git_prompt)'
local venv='%{$limegreen%}$(virtualenv_info)%{$reset_color%}'
local rvm_ruby='$(rvm_prompt)'

# $terminfo[bold]
# %{$gray%}
# PROMPT=$'%{$limegreen%}%~%{$reset_color%} %{$terminfo[bold]%}$vcs_info_msg_0_ %{$terminfo[bold]$limeblue%}$(virtualenv_info)%{$gray%}$ '
PROMPT="%{$reset_color%}%{$gray%}%n@%m ${pwd}${git}${venv}${rvm_ruby}${pointer}"
# RPROMPT=$'%{$reset_color%}%{$gray%}%n@%m'  # user@host

# enable VCS systems you use
# autoload -U add-zsh-hook
# autoload -Uz vcs_info
# PR_GIT_UPDATE=1

# zstyle ':vcs_info:*' enable git svn

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
# zstyle ':vcs_info:*:prompt:*' check-for-changes true

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stagedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
# PR_RST="%{${reset_color}%}"
# FMT_BRANCH="%{$terminfo[bold]$yellow%}(%b%u%c${PR_RST}%{$terminfo[bold]$yellow%})"
# FMT_ACTION="(%{$limegreen%}%a${PR_RST})"
# FMT_UNSTAGED="%{$orange%}*"
# FMT_STAGED="%{$darkyellow%}+"

# zstyle ':vcs_info:*:prompt:*' unstagedstr   "${FMT_UNSTAGED}"
# zstyle ':vcs_info:*:prompt:*' stagedstr     "${FMT_STAGED}"
# zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
# zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
# zstyle ':vcs_info:*:prompt:*' nvcsformats   ""

# function __preexec {
#     case "$(history $HISTCMD)" in
#         *git*)
#             PR_GIT_UPDATE=1
#             ;;
#         *svn*)
#             PR_GIT_UPDATE=1
#             ;;
#     esac
# }
# add-zsh-hook preexec __preexec

# function __chpwd {
#     PR_GIT_UPDATE=1
# }
# add-zsh-hook chpwd __chpwd

# function __precmd {
#     if [[ -n "$PR_GIT_UPDATE" ]] ; then
#         # check for untracked files or updated submodules, since vcs_info doesn't
#         if git ls-files --other --exclude-standard --directory 2> /dev/null | grep -q "."; then
#             PR_GIT_UPDATE=1
#             FMT_BRANCH="%{$terminfo[bold]$yellow%}(%b%u%c%{$hotpink%}●${PR_RST}%{$terminfo[bold]$yellow%})"
#         # else
#         #    FMT_BRANCH="(%{$turquoise%}%b%u%c${PR_RST})"
#         fi
#         zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"

#         vcs_info 'prompt'
#         PR_GIT_UPDATE=
#     fi
# }
# add-zsh-hook precmd __precmd
