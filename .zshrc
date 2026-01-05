# (Order matters: local first, then homebrew, then system)
export PATH="$HOME/.local/bin:/opt/homebrew/bin:$PATH"

# Calculate where Homebrew lives once so we don't ask it twice
BREW_PREFIX=$(brew --prefix)

eval "$(starship init zsh)"
source <(fzf --zsh)

# Zoxide: Use '--cmd cd' to force zoxide to replace 'cd' natively/safely
eval "$(zoxide init zsh --cmd cd)"

alias python="python3"
alias v="nvim"
alias lg="lazygit"
# Note: 'alias cd="z"' is removed because line 13 handles it better

alias ls="eza -1 --icons --group-directories-first"
alias ll="eza -ll --icons --group-directories-first"
alias la="eza -la --icons --group-directories-first"
alias cat="bat"
alias del="trash"

# 5. Plugins
# Source autosuggestions first
source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# 6. FINAL LINE: Syntax Highlighting
# This MUST be last. It needs to see all your aliases to highlight them correctly.
source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
mdcd() {
mkdir -p "$@" && cd "$@"
}
function chpwd() {
    ls
}
alias vim='nvim'
