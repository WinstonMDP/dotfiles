source ~/other/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
antigen bundle virtualenv
antigen bundle chrissicool/zsh-256color

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme sobolevn/sobole-zsh-theme

SOBOLE_THEME_MODE=dark

# Tell Antigen that you're done.
antigen apply

export VISUAL=nvim
