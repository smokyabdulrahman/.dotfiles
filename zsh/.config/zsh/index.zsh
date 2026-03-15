source $HOME/.config/secrets.zsh
# 1password
op inject --in-file "${HOME}/.config/zsh/env.zsh" | while read -r line; do
  eval "$line"
done
source $HOME/.config/zsh/starship.zsh
source $HOME/.config/zsh/aliases.zsh


# setup fzf
source <(fzf --zsh)

