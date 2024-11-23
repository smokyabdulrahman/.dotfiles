# personal
alias wrk="cd ~/work"
alias crpr="gh pr create"

# zsh
alias zshr='source ~/.zshrc'

# ls
alias ll='ls -al'

# git stuff
alias gst='git status'

alias gc='git commit -m'
alias gca='git commit -am'

alias gco='git checkout'
alias gcb='git checkout -b'

alias ga='git add'
alias gaa='git add .'

alias gdf='git diff head'

alias gp='git push'
alias gl='git pull'

alias kamal='docker run -it --rm -v "${PWD}:/workdir" -v "/run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock" -e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/basecamp/kamal:latest'
