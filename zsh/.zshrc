# Powerlevel10k Instant Prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Optimize compinit
autoload -Uz compinit
local cache_file="$HOME/.zcompdump"
if [[ -n "$cache_file"(N.mh+24) ]]; then
  compinit -i -C "$cache_file"
else
  compinit -i
fi

# ===================================================
# Environment Setup
# ===================================================
if [ -f ~/.env ]; then
    export $(grep -v '^#' ~/.env | xargs)
fi
export EDITOR=nvim
export SDKMAN_DIR="$HOME/.sdkman"
export PATH="/opt/homebrew/bin:/usr/local/opt/libpq/bin:/opt/homebrew/opt/libpq/bin:/Users/wiscaksono/Applications/instantclient_19_8:/Users/wiscaksono/.deno/bin:/Users/wiscaksono/.bun/bin:/Users/wiscaksono/.go/bin:/usr/local/go/bin:/opt/homebrew/opt/ruby/bin:$PATH:/Users/wiscaksono/Applications/apache-maven-3.9.6/bin:/Users/wiscaksono/Applications/flutter/bin"
export REACT_EDITOR=nvim
export DENO_INSTALL="/Users/wiscaksono/.deno"
export BUN_INSTALL="$HOME/.bun"
export NODE_COMPILE_CACHE="$HOME/.cache/nodejs-compile-cache"

BREW_PREFIX="/opt/homebrew"
export PNPM_HOME="/Users/wiscaksono/Library/pnpm"

# Oracle-related
export ORACLE_HOME="/Users/wiscaksono/Applications/instantclient_19_8"
export DYLD_LIBRARY_PATH="/Users/wiscaksono/Applications/instantclient_19_8"
export LD_LIBRARY_PATH="/Users/wiscaksono/Applications/instantclient_19_8"
export OCI_LIB_DIR="/Users/wiscaksono/Applications/instantclient_19_8"
export OCI_INC_DIR="/Users/wiscaksono/Applications/instantclient_19_8/sdk/include"

# ===================================================
# Shell and Zsh Configuration
# ===================================================

# FZF Configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Powerlevel10k Theme
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ===================================================
# Function Definitions
# ===================================================
f() {
    local dir
    dir=$(find * -type d -not -path '*/node_modules/*' -not -path '*/.git/*' -not -path '*/\.*' 2>/dev/null | fzf --preview 'tree -C {}' --reverse)
    [ -n "$dir" ] && builtin cd "$dir"
}

ssh() {
  case "$1" in
    nugs)
      sshpass -p "$SSH_NUGS_PASSWORD" ssh -o StrictHostKeyChecking=no "$SSH_NUGS_USER@$SSH_NUGS_IP"
      ;;
    ajs)
      sshpass -p "$SSH_AJS_PASSWORD" ssh -o StrictHostKeyChecking=no "$SSH_AJS_USER@$SSH_AJS_IP"
      ;;
    idch)
      sshpass -p "$SSH_IDCH_PASSWORD" ssh -o StrictHostKeyChecking=no "$SSH_IDCH_USER@$SSH_IDCH_IP"
      ;;
    *)
      command ssh "$@"
      ;;
  esac
}

# ===================================================
# SDKMAN Lazy Loading
# ===================================================
# Ensure SDKMAN_DIR is set (should be already set earlier in your config)
# export SDKMAN_DIR="$HOME/.sdkman"

# Variable to track SDKMAN load state (0 = not loaded, 1 = loaded)
_sdkman_loaded=0

# Function to load SDKMAN if not already loaded
_lazy_load_sdkman() {
  # Check if already loaded
  if [[ "$_sdkman_loaded" -eq 1 ]]; then
    return 0 # Already loaded, success
  fi

  # Check if the init script exists
  if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    # Source the init script
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
    # Mark as loaded
    _sdkman_loaded=1
    # Clear Zsh's command hash table so it finds the new commands
    hash -r
    return 0 # Success
  else
    echo "Zsh Lazy Load Error: SDKMAN init script not found at $SDKMAN_DIR/bin/sdkman-init.sh" >&2
    return 1 # Failure
  fi
}

# ===================================================
# Aliases
# ===================================================
# General Aliases
alias ..="cd .."
alias n="nvim"
alias c="clear"
alias cat="bat"
alias cd="z"

# Git Aliases
alias ginit="git init ."
alias gadd="git add ."
alias gc="git commit -m"
alias gp="git pull"
alias gpu="git push"
alias gf="git fetch"
alias grh="git reset --hard"
alias gadog="git log --all --decorate --oneline --graph"
alias gco="git checkout"
alias gcl="git clone"

# Package Manager Aliases
alias ns="npm start"
alias nrd="npm run dev"
alias ni="npm install"
alias y="yarn"
alias yd="yarn dev"
alias ys="yarn start"
alias b="bun"
alias bi="bun install"
alias bu="bun update"
alias brd="bun run dev"

# Language-Specific Aliases
alias cr="cargo run"
alias ct="cargo test"
alias cb="cargo build"
alias g="go"
alias gr="go run"
alias grm="go run main.go"

# Directory Aliases
alias d="cd ~/Developer/"
alias dp="cd ~/Developer/PERSONAL/"
alias ds="cd ~/Developer/SINARMAS/"
alias dsb="cd ~/Developer/SANDBOX/"

# Exa Aliases (for improved listing)
alias l='eza -lh'
alias ll='eza -lah'
alias la='eza -A'
alias lm='eza -m'
alias lr='eza -R'
alias lg='eza -l --group-directories-first'

# Custom Aliases
alias disable-sleep='sudo pmset disablesleep 1'
alias enable-sleep='sudo pmset disablesleep 0'
alias tat="tmux attach -t"
alias nvc="cd ~/.config/nvim && nvim ."
alias polaris="~/.launcher/polaris.sh"

# ===================================================
# Autocompletion and Plugin Sources
# ===================================================
source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh
source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh-vi-mode/zsh-vi-mode.plugin.zsh

# Source Angular CLI completions from file (generate with: ng completion script > ~/.zsh/ng_completion.zsh)
[[ -s "$HOME/.zsh/ng_completion.zsh" ]] && source "$HOME/.zsh/ng_completion.zsh"

# Load other tools
eval "$(rbenv init - zsh)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"
eval "$(~/.local/bin/mise activate)"

# Bun completions
[ -s "/Users/wiscaksono/.bun/_bun" ] && source "/Users/wiscaksono/.bun/_bun"
export PATH="${HOME}/.local/bin":${PATH}

export PATH="/Users/wiscaksono/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/Users/wiscaksono/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/wiscaksono/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
