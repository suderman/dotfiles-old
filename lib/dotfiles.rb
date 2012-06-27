#!/usr/bin/env ruby

require 'rubygems'
require 'fileutils'
include FileUtils

# Install dotfiles
class DotFiles

  def initialize(sources=[])

    @sources = sources.each { |source| File.expand_path source }
    @home = File.expand_path "~"

    puts blue("Running dotfiles install")
    install [@sources.first]	
  end


  # Recursively walk through each source
  def install(files)
    files.each do |file|	

      # Determine what kind of file we're dealing with
      case this_kind_of file 

      # Go deeper on directories
      when :dir
        install new_files(file)

      # Unzip contents and go deeper
      when :symlink
        # do symlink stuff
        # path = `head -n 1 "#{file}"`.strip
      end
    end
  end


  # Determine what kind of file
  def this_kind_of(file)

    # Check if the extension is .symlink
    return :symlink if File.extname(file) == '.symlink'

    # Else, check if it's a directory
    return :dir if File.directory? file

    # It's a regular file
    :file
  end


  # Find new sources inside a directory
  def new_files(path)

    # Look for known file extensions
    files = Dir.glob "#{path}/*.symlink" 

    # Also look for directories 
    directories = Dir.entries(path).select do |f| 
      File.directory? "#{path}/#{f}" \
      and !(File.symlink? "#{path}/#{f}") \
      and !(f.match(/^(\.)/i))
    end

    # Combine files with directories (prepending full path to each directory)
    files |= directories.each_with_index { |dir, i| directories[i] = "#{path}/#{dir}" }
  end

  # Ask for permission
  def ask(prompt)
    print yellow("#{prompt} [y/n]"), ' '
    $stdin.gets.strip.match /^y/i
  end

  # Pretty colours
  def red(text)    "\033[31m#{text}\033[m" end
  def green(text)  "\033[32m#{text}\033[m" end
  def yellow(text) "\033[33m#{text}\033[m" end
  def blue(text)   "\033[34m#{text}\033[m" end
  def gray(text)   "\033[37m#{text}\033[m" end

end
