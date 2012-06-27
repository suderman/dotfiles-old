#!/usr/bin/env ruby
require 'rubygems'

dropbox_lib = File.expand_path "~/Dropbox/Library"
home_lib = File.expand_path "~/Library"

# Each directory under ~/Dropbox/Library
Dir.foreach dropbox_lib do |app|
  next if app == '.' or app == '..'
  next unless File.directory? "#{dropbox_lib}/#{app}"

  # Symlink the Fonts directory
  if app == 'Fonts'
    command = "ln -sfn \"#{dropbox_lib}/#{app}\" \"#{home_lib}/#{app}\""
    puts command
    system command
    next
  end

  # Each directory under ~/Dropbox/Library/some-app-name
  Dir.foreach "#{dropbox_lib}/#{app}" do |dir|
    next if dir == '.' or dir == '..'
    next unless File.directory? "#{dropbox_lib}/#{app}/#{dir}"

    # Symlink the Application Support directory
    if dir == 'Application Support'
      command = "ln -sfn \"#{dropbox_lib}/#{app}/#{dir}\" \"#{home_lib}/Application Support/#{app}\""
      puts command
      system command

    # Symlink all files inside Preferences
    elsif dir == 'Preferences'
      Dir.glob "#{dropbox_lib}/#{app}/#{dir}/*" do |file|
        file = File.basename file
        next if File.directory? "#{dropbox_lib}/#{app}/#{dir}/#{file}"

        command = "ln -sfn \"#{dropbox_lib}/#{app}/#{dir}/#{file}\" \"#{home_lib}/Preferences/#{file}\""
        puts command
        system command

      end
    end
  end
end
