set -g fish_greeting

set -gx VISUAL helix
set -gx EDITOR $VISUAL

set -gx _JAVA_AWT_WM_NONREPARENTING 1

fish_add_path /usr/lib/rustup/bin

starship init fish | source
zoxide init fish | source

abbr --add zf zathura --fork
abbr --add hx helix
