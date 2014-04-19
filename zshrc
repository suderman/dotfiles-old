source $HOME/.antigen/antigen.zsh

# Must be loaded first
antigen bundle $HOME/.dotfiles/zsh/bundles/fzf

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

antigen bundle osx 
antigen bundle git
antigen bundle heroku
antigen bundle colored-man
antigen bundle brew 
antigen bundle brew-cask 
antigen bundle tmux 
antigen bundle autojump 
antigen bundle nyan 
# antigen bundle npm 
# antigen bundle chruby 
# antigen bundle gem 
# antigen bundle rails 
# antigen bundle pip
# antigen bundle command-not-found
# antigen bundle extract 

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search

antigen bundle $HOME/.dotfiles/zsh/bundles/vi-visual

# Load the theme.
antigen theme flazz

# Tell antigen that you're done.
antigen apply

# Doesn't work as a bundle for some reason
source $HOME/.dotfiles/zsh/bundles/opp/opp.plugin.zsh

# My configuration
source $HOME/.dotfiles/zsh/path.zsh
source $HOME/.dotfiles/zsh/config.zsh
source $HOME/.dotfiles/zsh/aliases.zsh
source $HOME/.dotfiles/zsh/functions.zsh

