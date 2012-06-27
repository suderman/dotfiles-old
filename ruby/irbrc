# print SQL to STDOUT
if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')
  require 'logger'
  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
end

# Autocomplete
require 'irb/completion'

# Prompt behavior
ARGV.concat [ "--readline", "--prompt-mode", "simple" ]

# History
require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"

# Easily print methods local to an object's class
class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end
end

# Original
# # load libraries
# require 'rubygems'
# require 'irb/completion'
# require 'wirble'
# require 'pp'
# 
# IRB.conf[:AUTO_INDENT]=true
# 
# ARGV.concat [ "--readline", "--prompt-mode", "simple" ]
# 
# # start wirble (with color)
# Wirble.init
# Wirble.colorize