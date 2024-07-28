set -g fish_greeting

set -gx VISUAL hx
set -gx EDITOR $VISUAL

set -gx _JAVA_AWT_WM_NONREPARENTING 1

set -gx GOPATH $HOME/builded/go

set -gx HELIX_RUNTIME $HOME/builded/helix/runtime

fish_add_path /usr/lib/rustup/bin
fish_add_path $HOME/builded/helix/target/release
fish_add_path $GOPATH/bin

starship init fish | source
zoxide init fish | source
