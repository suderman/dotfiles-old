#!/usr/bin/env ruby

require 'rubygems'
require './lib/dotutils'
include DotUtils

# Install oh-my-zsh
git '~/.oh-my-zsh', :url => 'git://github.com/robbyrussell/oh-my-zsh.git' do
  `cd ~/.oh-my-zsh && rm -rf .gitignore custom`
end

# Install dotfiles-secure 
git 'secure', :url => 'git@github.com:suderman/dotfiles-secure.git'

# Symlink the dotfiles
symlink "symlinks"
