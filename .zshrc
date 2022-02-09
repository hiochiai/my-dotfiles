export PATH=$PATH:~/bin/my-tools

alias jq="docker run --rm -i stedolan/jq </dev/stdin"
alias tree="docker run --rm -i -v $(pwd):/usr/src -w /usr/src tree"

alias gs="git status"
alias gl="git log --oneline --decorate --graph --branches --tags --remotes"
alias gd="git diff"

# golang
export GOPATH=$HOME/Projects/go
export PATH=$PATH:$GOPATH/bin

# gcloud
if [ -f ~/bin/google-cloud-sdk/path.zsh.inc ]; then . ~/bin/google-cloud-sdk/path.zsh.inc; fi
if [ -f ~/bin/google-cloud-sdk/completion.zsh.inc ]; then . ~/bin/google-cloud-sdk/completion.zsh.inc; fi
