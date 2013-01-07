#!/bin/sh

# 2013 Jon Suderman
# https://github.com/suderman/dotfiles/

# Open a terminal and run this command:
# curl https://raw.github.com/suderman/dotfiles/master/install.sh | sh


# Check for and install git
command -v git >/dev/null 2>&1 || {

  # Git not found; install app (if not already installed)
  case $OSTYPE in

    # Install Git on Ubuntu
    linux* ) echo "Installing Git on Linux"
      sudo apt-get install git-core
      break;;

    # Install Git on OS X
    darwin* ) echo "Installing Git on OS X"
      command -v app >/dev/null 2>&1 || { curl https://raw.github.com/suderman/app/master/install.sh | sh; }
      app "http://git-osx-installer.googlecode.com/files/git-1.7.11.1-intel-universal-snow-leopard.dmg"
      export PATH=$PATH:/usr/local/git/bin
      break;;

  esac
}


# Check for and install oh-my-zsh
if [ ! -d ~/.oh-my-zsh ]; then

  OHMYZSH_REPO="git://github.com/robbyrussell/oh-my-zsh.git"

  echo "Installing ~/.oh-my-zsh"
  git clone $OHMYZSH_REPO ~/.oh-my-zsh

  # Remove these files/directories because they'll be symlinked from dotfiles
  cd ~/.oh-my-zsh && rm -rf .gitignore custom

fi


# Check for and install dotfiles
if [ ! -d ~/.dotfiles ]; then

  # Install dotfiles
  if [ -f ~/.ssh/id_rsa ]
  then DOTFILES_REPO="git@github.com:suderman/dotfiles.git"
  else DOTFILES_REPO="https://suderman@github.com/suderman/dotfiles.git"
  fi

  echo "Installing ~/.dotfiles"
  git clone $DOTFILES_REPO ~/.dotfiles

  # Install dotfiles-secure
  echo ""; read -p "Install secure dotfiles (including private key)? [y/n] " yn
  case $yn in
    [Yy]* ) echo ""; echo "Installing ~/.dotfiles/secure"

      if [ -f ~/.ssh/id_rsa ]
      then DOTFILES_REPO="git@github.com:suderman/dotfiles-secure.git"
      else DOTFILES_REPO="https://suderman@github.com/suderman/dotfiles-secure.git"
      fi

      git clone $DOTFILES_REPO ~/.dotfiles/secure
  esac

  # SSH complains if these files have the wrong permissions
  chmod go-rw ~/.dotfiles/secure/ssh/*

fi


# Check for symlink and create symbolic links
command -v symlink >/dev/null 2>&1 || { curl https://raw.github.com/suderman/symlink/master/install.sh | sh; }
cd ~/.dotfiles && symlink symlinks.yml


# Now that SSH is all set up, update remote origins for password-less pushing
if [ -f ~/.ssh/id_rsa ]; then
  cd ~/.dotfiles && git remote set-url origin git@github.com:suderman/dotfiles.git
  cd ~/.dotfiles/secure && git remote set-url origin git@github.com:suderman/dotfiles-secure.git
fi


# OS X apps, library and settings
case $OSTYPE in darwin*) 
  osascript -e 'tell app "Terminal"
  do script "cd ~/.osx && ./osx.sh"
  end tell'
;; esac
