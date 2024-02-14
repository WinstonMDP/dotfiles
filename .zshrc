source ~/other/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

export VISUAL=helix
export EDITOR="$VISUAL"

alias hx="helix"

function z () {
    __zoxide_z "$@"
}
eval "$(zoxide init zsh --no-cmd)"

eval "$(starship init zsh)"
