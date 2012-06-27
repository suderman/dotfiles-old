#!/usr/bin/env ruby

require 'rubygems'
require 'pathname'
require 'fileutils'
include FileUtils

module OSXUtils

  # Does a command exist?
  def command?(name)
    system "type #{name} &> /dev/null"
  end

  # Install a new command
  def command(name, options={})

    puts "\n[#{green(name)}]"

    if command? name
      puts "...already installed!"
    else
      system "#{options[:command]}"
      yield if block_given?
    end

  end

  # Has this brew recipe been installed?
  def brew?(name)

    unless command? 'brew'
      puts red("[error] Homebrew is not installed!") 
      return false
    end

    system "brew ls | grep #{name} &> /dev/null"
  end

  # Install a new brew recipe
  def brew(name_with_args, options={})

    name = name_with_args.split(' ')[0]
    puts "\n[#{green(name)}]"

    unless command? 'brew'
      puts red("[error] Homebrew is not installed!") 
      return false
    end

    if brew? name
      puts "...already installed!"
    else
      system "brew tap #{options[:tap]}" if options[:tap]
      system "brew install #{name_with_args}"
      yield if block_given?
    end

  end

  # Has this node package been installed?
  def npm?(name)

    unless command? 'npm'
      puts red("[error] npm is not installed!") 
      return false
    end

    system "npm -g ls | grep #{name} &> /dev/null"
  end

  # Install a new node package
  def npm(name)

    puts "\n[#{green(name)}]"

    unless command? 'npm'
      puts red("[error] npm is not installed!") 
      return false
    end

    if npm? name
      puts "...already installed!"
    else
      system "npm install #{name} -g"
    end

  end


  # Has this node package been installed?
  def installed?(name)

    unless command? 'installion'
      puts red("[error] installion is not installed!") 
      return false
    end

    # First see if the name is a command
    return true if command? name

    # Otherwise, check for different app types
    case name.split('.').last.downcase.to_sym

    when :app
      return true if find? "/Applications", name
      return true if find? "~/Applications", name

    when :prefpane
      return true if find? "~/Library/PreferencePanes", name
      return true if find? "/Library/PreferencePanes", name

    when :service
      return true if find? "~/Library/Services", name
      return true if find? "/Library/Services", name

    when :plugin
      return true if find? "~/Library/Internet Plug-Ins", name
      return true if find? "/Library/Internet Plug-Ins", name

    when :safariextz
      return true if find? "~/Library/Safari/Extensions", name
    end

    false
  end

  # Install a new app with installion 
  def install(name, options={})

    puts "\n[#{green(name)}]"

    unless command? 'installion'
      puts red("[error] installion is not installed!") 
      return false
    end

    if installed? name
      puts "...already installed!"

    else
      open = (options[:open]) ? '-o ' : ''
      source = parse_source options[:source]
      system "installion #{open}-f \"#{options[:source]}\""
      yield if block_given?
    end
  end

  def find?(path, name)
    path = File.expand_path path
    results = `sudo find "#{path}" -iname "#{name}" | head -n 1`.strip
    true unless results.empty?
  end

  def parse_source(source)
    case source
    when /^[a-zA-Z0-9_]*\/[a-zA-Z0-9_\-\s]*\.[a-zA-Z0-9_]*/i
      "https://dl.dropbox.com/s/#{source}"
    else
      source
    end
  end

  # Pretty colours
  def red(text)    "\033[31m#{text}\033[m" end
  def green(text)  "\033[32m#{text}\033[m" end
  def yellow(text) "\033[33m#{text}\033[m" end
  def blue(text)   "\033[34m#{text}\033[m" end
  def gray(text)   "\033[37m#{text}\033[m" end

end
