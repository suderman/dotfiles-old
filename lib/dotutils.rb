#!/usr/bin/env ruby

require 'rubygems'
require 'fileutils'
include FileUtils

module DotUtils

  # Does a command exist?
  def command?(name)
    system "type #{name} &> /dev/null"
  end

  def git?(path)
    File.exists?(File.expand_path path)
  end

  # Install a new git repo
  def git(path, options={})

    puts "\n[#{green(path)}]"

    if git? path
      puts "...already installed!"
    else
      system "git clone #{options[:url]} #{path}"
      yield if block_given?
    end

  end


  # Recursively walk through each source
  def symlink(files)

    if files.class.to_s == 'String'
      @home = File.expand_path "~"
      @base = "#{File.expand_path(files).split('/').last}/"

      puts "\n[#{green('Creating symbolic links')}]"
      files = new_files(files)
    end

    files.each do |file|	

      # Determine what kind of file we're dealing with
      case this_kind_of file 

      # Go deeper on directories
      when :dir
        symlink new_files(file)

      # Unzip contents and go deeper
      when :file
        points_to = `head -n 1 "#{file}"`.strip
        source = File.expand_path "#{File.dirname(__FILE__)}/../#{points_to}"
        ln_sf source, dotname(file)
        puts gray(source) + blue(" => ") + gray(dotname(file))
      end

    end
  end


  # Determine what kind of file
  def this_kind_of(file)
    (File.directory? file) ? :dir : :file
  end


  # Find new sources inside a directory
  def new_files(directory)

    files = Dir.entries(directory).select do |file| 
      !(File.symlink? "#{directory}/#{file}") \
      and !(file.match(/^(\.|_)/i))
    end

    files.each_with_index do |file, i| 
      files[i] = "#{directory}/#{file}"
    end

  end


  # Get the dotnamed path, creating directories as you go
  def dotname(path)

    path = File.expand_path "#{@home}/.#{path.split(@base).last}" 
    dir = File.dirname(path)
    file = File.basename(path)

    # Add a dot to the filename for special cases
    dot = ''
    dot = '.' if ['gitignore'].include? file 

    # Create any needed directories and return the path
    mkdir_p dir 
    "#{dir}/#{dot}#{file}"
  end



  # Pretty colours
  def red(text)    "\033[31m#{text}\033[m" end
  def green(text)  "\033[32m#{text}\033[m" end
  def yellow(text) "\033[33m#{text}\033[m" end
  def blue(text)   "\033[34m#{text}\033[m" end
  def gray(text)   "\033[37m#{text}\033[m" end

end
