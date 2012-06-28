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


  # Has this app been installed?
  def app?(name)

    unless command? 'app'
      puts red("[error] app is not installed!") 
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

  # Install a new app with app 
  def app(name, options={})

    puts "\n[#{green(name)}]"

    if app? name
      puts "...already installed!"

    else

      # Install an app with app
      if options[:src]

        unless command? 'app'
          puts red("[error] app is not installed!") 
          return false
        end

        open = (options[:open]) ? '-o ' : ''
        source = parse options[:src]
        system "app #{open}-f \"#{source}\""

      # Open an URL (website or App Store)
      elsif options[:url]
        url = parse options[:url]
        system "open #{url}"
        say 'Click "Install" on the App Store' if url.match /^macappstore/i
      end

      yield if block_given?
    end
  end


  def find?(path, name)
    path = File.expand_path path
    results = `sudo find "#{path}" -iname "#{name}" | head -n 1`.strip
    true unless results.empty?
  end


  def parse(source)
    case url

    # App Store => sparrow/id417250177 
    when /^[a-zA-Z0-9_\-]*\/id[0-9]*$/i
      "macappstore://itunes.apple.com/ca/app/#{source}"

    # Dropbox => zmlm47fmbqcnwl7/GCC-10.7-v2.pkg
    when /^[a-zA-Z0-9_]*\/[a-zA-Z0-9_\-\s]*\.[a-zA-Z0-9_]*$/i
      "https://dl.dropbox.com/s/#{source}"

    else
      source
    end
  end


  def sync_library(libs)

    home_lib = File.expand_path libs[:home]
    cloud_lib = File.expand_path libs[:cloud]

    # Each directory under ~/Dropbox/Library
    Dir.foreach cloud_lib do |app|
      next if app == '.' or app == '..'
      next unless File.directory? "#{cloud_lib}/#{app}"

      # Symlink the Fonts directory
      if app == 'Fonts'
        command = "ln -sfn \"#{cloud_lib}/#{app}\" \"#{home_lib}/#{app}\""
        puts command
        system command
        next
      end

      # Each directory under ~/Dropbox/Library/some-app-name
      Dir.foreach "#{cloud_lib}/#{app}" do |dir|
        next if dir == '.' or dir == '..'
        next unless File.directory? "#{cloud_lib}/#{app}/#{dir}"

        # Symlink the Application Support directory
        if dir == 'Application Support'
          command = "ln -sfn \"#{cloud_lib}/#{app}/#{dir}\" \"#{home_lib}/Application Support/#{app}\""
          puts command
          system command

        # Symlink all files inside Preferences
        elsif dir == 'Preferences'
          Dir.glob "#{cloud_lib}/#{app}/#{dir}/*" do |file|
            file = File.basename file
            next if File.directory? "#{cloud_lib}/#{app}/#{dir}/#{file}"

            command = "ln -sfn \"#{cloud_lib}/#{app}/#{dir}/#{file}\" \"#{home_lib}/Preferences/#{file}\""
            puts command
            system command

          end
        end
      end
    end

  end


  # Set a system preference
  def set(description, *commands)
    if commands.size > 0
      puts "\n[#{green(description)}]"
      commands.each do |command|
        puts yellow(' => ') + gray(command)
        system command 
      end
    end
  end


  # Ask for permission
  def ask(prompt)
    print yellow("#{prompt} [y/n]"), ' '
    $stdin.gets.strip.match /^y/i
  end


  # Stop and say something
  def say(message)
    print yellow("#{message} [OK?]"), ' '
    $stdin.gets.strip
  end


  # Pretty colours
  def red(text)    "\033[31m#{text}\033[m" end
  def green(text)  "\033[32m#{text}\033[m" end
  def yellow(text) "\033[33m#{text}\033[m" end
  def blue(text)   "\033[34m#{text}\033[m" end
  def gray(text)   "\033[37m#{text}\033[m" end

end
