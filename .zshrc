# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

setopt share_history

autoload -Uz promptinit
promptinit
prompt powerlevel10k

export PATH="$HOME/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# setting GOPATH
eval "$(goenv init -)"
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"

# setting peco and ghq
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

# setting peco for gcloud
# https://qiita.com/sonots/items/906798c408132e26b41c
function gcloud-activate() {
  name="$1"
  project="$2"
  echo "gcloud config configurations activate \"${name}\""
  gcloud config configurations activate "${name}"
}
function gx-complete() {
  _values $(gcloud config configurations list | awk '{print $1}')
}
function gx() {
  name="$1"
  if [ -z "$name" ]; then
    line=$(gcloud config configurations list | peco)
    name=$(echo "${line}" | awk '{print $1}')
  else
    line=$(gcloud config configurations list | grep "$name")
  fi
  project=$(echo "${line}" | awk '{print $4}')
  gcloud-activate "${name}" "${project}"
}
compdef gx-complete gx

# pyenv setting
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/shims:$PATH"
eval "$(pyenv init -)"

# add history size
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

#alias
#git系
alias g='git'
alias ga='git add'
alias gd='git diff'
alias gs='git status'
alias gp='git push'
alias gb='git branch'
alias gst='git status'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gf='git fetch'
alias gc='git commit'
alias gcm='git commit -m'

#docker
alias dc='docker compose'
alias dcb='docker compose build'
alias dcu='docker compose up'
alias dcud='docker compose up -d'
alias dcd='docker compose down'
alias drm='docker rm'
alias drmi='docker rmi'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="$HOME/bin:$PATH"

# java11
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@11/include"

# jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
export PATH="$HOME/bin:$PATH"

export PATH="$HOME/.poetry/bin:$PATH"

[ -f ~/.zshrc.aliases ] && source ~/.zshrc.aliases
export PATH="/opt/homebrew/bin:$PATH"
export PATH=$HOME/.nodebrew/current/bin:$PATH


# export DOCKER_IMAGE=line-mock
# export IMAGE_PATH="$PROJECT_ID/$DOCKER_IMAGE:latest"
export HISTTIMEFORMAT='%F %T '
alias history='history -i'

export PATH=$PATH:$(go env GOPATH)/bin
