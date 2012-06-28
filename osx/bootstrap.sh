#!/bin/sh
# curl https://raw.github.com/suderman/dotfiles/master/osx/bootstrap.sh | sh

# URL to git installer
GIT="https://dl.dropbox.com/s/y80vt8720xrv5h0/git.pkg"

# Install git
echo "Downloading Git"
curl "$GIT" -o /tmp/git.pkg
echo "Installing Git"
sudo installer -pkg /tmp/git.pkg -target /

# Install dotfiles
echo "Cloning dotfiles"
/usr/local/git/bin/git clone https://suderman@github.com/suderman/dotfiles.git ~/.dotfiles
echo "Installing dotfiles"
cd ~/.dotfiles && ./install.rb
source ~/.zshrc

# OS X apps, library and settings
echo "OS X apps, library and settings"
cd ~/.osx && ./install.rb
