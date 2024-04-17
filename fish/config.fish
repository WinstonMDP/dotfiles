set -g fish_greeting

abbr -a hx helix

set -gx VISUAL helix
set -gx EDITOR $VISUAL

set -gx _JAVA_AWT_WM_NONREPARENTING 1

fish_add_path /usr/lib/rustup/bin

starship init fish | source
zoxide init fish | source
