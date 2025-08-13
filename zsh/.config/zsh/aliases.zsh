# personal
alias vim="nvim"
alias wrk="cd ~/work"
alias crpr="gh pr create --fill-first"
# alias watch to expand other aliases before calling watch
# which runs the commands in a /bin/sh that doesn't know
# about the defined aliases in zsh
alias watch="watch -c -t "

# todo.txt
alias t="todo.sh"
alias tls="t ls"

# docker
alias dps='docker ps --format "table {{.ID}}\\t{{.Image}}\\t{{.Status}}\\t{{.Names}}"'
alias dcu='docker compose up -d'
alias dcd='docker compose down'

# zsh
alias zshr='source ~/.zshrc'

# ls
alias ll='ls -al'

# git stuff
alias gcl='git clone'
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
