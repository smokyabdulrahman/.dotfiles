# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH
export XDG_CONFIG_HOME=$HOME/.config

ZSH_THEME="robbyrussell"

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi


# Created by `pipx` on 2024-01-21 09:28:16
export PATH="$PATH:/Users/aalrahma/.local/bin"

# bun completions
[ -s "/Users/aalrahma/.bun/_bun" ] && source "/Users/aalrahma/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# starship
eval "$(starship init zsh)"

source $HOME/.config/zsh/index.zsh
