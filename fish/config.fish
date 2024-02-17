if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx VISUAL helix
set -gx EDITOR $VISUAL

set -U fish_greeting
abbr -a hx helix

starship init fish | source
zoxide init fish | source
