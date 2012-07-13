#!/usr/bin/env ruby

require 'rubygems'
require './lib/dotutils'
include DotUtils

# Install oh-my-zsh
git '~/.oh-my-zsh', :repo => 'git://github.com/robbyrussell/oh-my-zsh.git' do |path|
  `cd #{path} && rm -rf .gitignore custom`
end

# Install dotfiles-secure 
git 'secure', :repo => 'suderman/dotfiles-secure' do |path|
  `chmod go-rw #{path}/ssh/*`
end

# Symlink the dotfiles
system "curl https://raw.github.com/suderman/symlink/master/install.sh | sh" unless command? 'symlink'
system "symlink ./symlinks.yml"
