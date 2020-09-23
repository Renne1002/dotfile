autoload -Uz add-zsh-hook

##################################################
# Key binding
##################################################
bindkey -d
bindkey -e
shift-arrow() {
  ((REGION_ACTIVE)) || zle set-mark-command
  zle $1
}
shift-left() shift-arrow backward-char
shift-right() shift-arrow forward-char
shift-up() shift-arrow up-line-or-history
shift-down() shift-arrow down-line-or-history
zle -N shift-left
zle -N shift-right
zle -N shift-up
zle -N shift-down
bindkey $terminfo[kLFT] shift-left
bindkey $terminfo[kRIT] shift-right
bindkey $terminfo[kri] shift-up
bindkey $terminfo[kind] shift-down

##################################################
# Colors
##################################################
autoload -Uz colors
colors

##################################################
# Completion
##################################################
autoload -Uz compinit
compinit

# case-insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ignore current-dir-command by completion
zstyle ':completion:*' ignore-parents parent pwd ..

# enable completion in following 'sudo'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                              /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# completion process name by 'ps'
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

##################################################
# Prompt
##################################################
# vsc_info
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '%F{white} - %F{cyan}[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{white} - %F{cyan}[%b%F{white} | %F{red}%a%F{white}]%f'

# prompt
function _update_prompt() {
    LANG=en_US.UTF-8 vcs_info
    PROMPT="%{${fg[yellow]}%}-------------------------------------------------------------
%{${reset_color}%}[%m %{${fg[cyan]}%}%n %{${fg[green]}%}%~%{${reset_color}%}]%{${vcs_info_msg_0_}%}
%{${fg[red]}%}%% %{${reset_color}%}"
}
add-zsh-hook precmd _update_prompt

##################################################
# Key operation
##################################################
# Don't quit zsh by 'Ctrl+D'
setopt ignore_eof

##################################################
# Alias and Function
##################################################
# common
alias reload='source ~/.zshrc'
alias sudo='sudo '
alias cls='clear'

# ls
alias ls='ls -G'
alias la='ls -Ga'
export LSCOLORS=gxfxcxdxbxegedabagacad

# colordiff
if [ -x "`which colordiff`" ]; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi
alias diffa="/usr/bin/diff --new-line-format='+%L' --old-line-format='-%L' --unchanged-line-format=' %L'"

# Git
alias gs='git status'
alias gd='git diff'
alias gdhh='git diff HEAD~1 HEAD'
alias gb='git branch'
alias gco='git checkout'
alias gcob='git checkout -b'
alias ga='git add'
alias gau='git add -u'
alias gaa='git add -A'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gcam='git commit --amend -m'
alias ggr="git log --graph --pretty=format:'%C(yellow)%cd %C(cyan)%h %C(bold blue)%an %Creset%s %C(red)%d' --abbrev-commit --date=short"
alias ggra="ggr --all"
alias gls="git ls-remote"
alias gbdm="git branch --merged | grep -vE '^\*|master$|develop$' | xargs -I % git branch -d %"
function gda() {
  local diff=""
  local h="HEAD"
  if [ $# -eq 1 ]; then
    if expr "$1" : '[0-9]*$' > /dev/null ; then
      diff="HEAD~${1} HEAD"
    else
      diff="${1} HEAD"
    fi
  elif [ $# -eq 2 ]; then
    diff="${2} ${1}"
    h=$1
  fi
  if [ "$diff" != "" ]; then
    diff="git diff --diff-filter=ACMR --name-only ${diff}"
  fi
  git archive --format=zip --prefix=root/ $h `eval $diff` -o archive.zip
}
function gpp() {
  local _list=`git ls-remote $1`
  local _array=(`echo $_list | grep pull/$2/head`)
  local _branch_name=`echo $_list | grep -E "${_array[1]}.+refs\/head" | sed -E "s/.+refs\/heads\/(.+)/\1/g"`
  git fetch $1 pull/$2/head:$_branch_name
}
function gfp() {
  [ -z "$1" -o -z "$1" ] && { echo 'Usage: gfp <remote> <branch>'; return 1 }
  git fetch $1 $2
  git reset --hard $1/$2
}

# bundler
alias be='bundle exec'

# vim
alias vi='vim'
alias via='vim +PluginInstall +qall'

# dcoker
alias d='docker'
alias fig='docker-compose'

# ReactNative
alias rn='react-native'

# VueNative
alias vn='vue-native'

# Node Versioning
alias n='nodenv'

# saml2aws
alias update-saml2aws='saml2aws login -a gsuite -p gsuite --skip-prompt --force'

##################################################
# Option
##################################################
# Histroy
setopt share_history
setopt histignorealldups
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Pushd
setopt auto_pushd
setopt pushd_ignore_dups

# Others
setopt nobeep

##################################################
# Env
##################################################
# colordiff like git diff
export LESS='-R'

# direnv
export EDITOR="code"
if which direnv > /dev/null; then eval "$(direnv hook zsh)"; fi

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# pyenv
export PYENV_ROOT="/usr/local/var/pyenv"
if which pyenv >/dev/null; then eval "$(pyenv init -)"; fi

# nodenv
if which nodenv > /dev/null; then eval "$(nodenv init -)"; fi

# mysql
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

# ReactNative Android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

##################################################
# Local Settings
##################################################
ZSHHOME="${HOME}/.zsh.d"
if [ -d $ZSHHOME -a -r $ZSHHOME -a -x $ZSHHOME ]; then
  for i in $ZSHHOME/*; do
    [[ ${i##*/} = *.zsh ]] && [ \( -f $i -o -h $i \) -a -r $i ] && . $i
  done
fi
