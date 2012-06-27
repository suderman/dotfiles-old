#!/usr/bin/env ruby

require 'rubygems'
require './lib/dotutils'
include DotUtils

# Install oh-my-zsh
git '~/.oh-my-zsh', :repo => 'robbyrussell/oh-my-zsh' do |path|
  `cd #{path} && rm -rf .gitignore custom`
end

# Install dotfiles-secure 
git 'secure', :repo => 'suderman/dotfiles-secure' do |path|
  `chmod go-rw #{path}/ssh/*`
end

# Symlink the dotfiles
symlink "symlinks"
