#!/usr/bin/env ruby

require 'rubygems'
require '../lib/osxutils'
include OSXUtils

# -- Installation --
if ask "Install OS X apps?" 

  # Install brew
  command "brew", :command => "/usr/bin/ruby -e '$(/usr/bin/curl -fsSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)'" do
   system "brew doctor" 
  end

  # Install app
  brew "app", :tap => "suderman/suds"

  # Install node & npm
  brew "node"
  command "npm", :command => "curl http://npmjs.org/install.sh | sh"

  app 'Dropbox.app', :src => '98shr7bfcuoo39o/Dropbox 1-2.4.7.dmg'

  app 'llvm-gcc', :src => '94pqy3oq1zt9xso/cltools_lion_latemarch12.dmg'
  app 'gcc', :src => 'zmlm47fmbqcnwl7/GCC-10.7-v2.pkg'

  # Install git & utilties
  brew "git"
  brew "tig"

  # Install MacVim, tmux & utilities
  brew "macvim"
  brew "tmux"
  brew "reattach-to-user-namespace"

  # Install rbenv & utilities
  brew "rbenv"
  brew "ruby-build"

  # Install a few nterchange essentials
  brew "php53 --with-mysql --with-cgi", :tap => "josegonzalez/homebrew-php"
  brew "nginx"
  npm "sng"
  npm "recess"
  npm "coffee-script"
  npm "uglify-js"
  npm "import"

  # Install a few other dev necessities
  brew "ack"
  npm "underscore"
  brew "imagemagick" do system "brew link imagemagick" end
  brew "mysql" do
    system "unset TMPDIR"
    system "mysql_install_db --verbose --user=`whoami` --basedir=\"$(brew --prefix mysql)\" --datadir=/usr/local/var/mysql --tmpdir=/tmp"
    system "mysql.server start"

    system "mkdir -p ~/Library/LaunchAgents"
    system "launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
    system "cp /usr/local/Cellar/mysql/5.5.25/homebrew.mxcl.mysql.plist ~/Library/LaunchAgents/"
    system "launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
  end	

  # Misc goodies
  brew "alpine"
  brew "autojump"
  brew "wget"

  # Set the installer directory
  `export APP_SOURCE=~/Dropbox/Installers`

  # Productivity
  app '1Password.app',                  :src => '1Password-3.8.19.zip'
  app 'Alfred.app',                     :src => 'alfred_1.2_220.dmg'
  app 'AppCleaner.app',                 :src => 'AppCleaner_2.1.zip'
  app 'Choosy.prefPane',                :src => 'choosy_1.0.3.zip'
  app 'CandyBar.app',                   :src => 'CandyBar 3.3.3.zip'
  app 'Fantastical.app',                :src => 'Fantastical_1.3.1.zip'
  app 'Fluid.app',                      :src => 'Fluid_1.4.zip'
  app 'HyperDock.prefpane',             :src => 'HyperDock.dmg'
  app 'KeyBindingsEditor.app',          :src => 'KeyBindingsEditor.dmg'
  app 'Keyboard Maestro.app',           :src => 'keyboardmaestro-53.zip'
  app 'Launchpad-Control.prefPane',     :src => 'Launchpad-Control.zip'

  # Media
  app 'Air Video Server.app',           :src => 'Air+Video+Server+2.4.3.dmg'
  app 'HandBrake.app',                  :src => 'HandBrake-0.9.6-MacOSX.6_GUI_x86_64.dmg'
  app 'Newzbin2 Client.app',            :src => 'Newzbin2Client-1.1.0.0.345.intel.app.zip'
  app 'PS3 Media Server.app',           :src => 'pms-macosx-1.52.1.dmg'
  app 'SABnzbd.app',                    :src => 'SABnzbd-0.6.15-osx.dmg'
  app 'Transmission.app',               :src => 'Transmission-2.52.dmg'
  app 'SMBUp.app',                      :src => 'SMBUp.1.4.zip'
  app 'VLC.app',                        :src => 'vlc-2.0.1.dmg'

  # Development
  app 'Google Chrome Canary.app',       :src => 'GoogleChromeCanary.dmg'
  app 'Firefox.app',                    :src => 'Firefox 13.0.dmg'
  app 'GitHub.app',                     :src => 'mac_GitHub for Mac 1.2.8.zip'
  app 'iTerm.app',                      :src => 'iTerm2-1_0_0_20120203.zip'
  app 'Paparazzi!.app',                 :src => 'Paparazzi! 0.5b6.dmg'
  app 'Sequel Pro.app',                 :src => 'Sequel_Pro_0-1.9.9.1.dmg'
  app 'TextMate.app',                   :src => 'TextMate_1.5.10_r1631.zip'
  app 'TextWrangler.app',               :src => 'TextWrangler_4.0.1.dmg'
  app 'TrackRecord 2.app',              :src => 'TrackRecord2.zip'
  app 'Transmit.app',                   :src => 'Transmit 4.1.9.zip'
  app 'VMware Fusion.app',              :src => 'VMware-Fusion-4-1.1.1-536016-light.dmg' do
    `rm -rf "/Applications/Getting Started.app"`
    `rm -rf "/Applications/Double-click to upgrade from VMware Fusion 3.app"`
  end

  # Creative
  app 'Scrivener.app',                  :src => 'Scrivener.dmg'
  app 'Aeon Timeline.app',              :src => 'AeonTimeline_1_0_0.dmg'
  app 'nvALT.app',                      :src => 'nvALT.zip'
  app 'Microsoft Word.app',             :src => 'X17-45975-1.dmg'
  app 'Adobe Photoshop CS6.app',        :src => 'Photoshop_13_LS16-1.dmg', :open => true
  app 'Adobe Fireworks CS6.app',        :src => 'Fireworks_12_LS16.dmg', :open => true

  # Utilities
  app 'MadCatzCyborgRAT.prefpane',      :src => 'CyborgRAT-1.1.28.zip'
  app 'Flash Player.prefPane',          :src => 'install_flash_player_osx.dmg', :open => true
  app 'Flip4Mac WMV.prefPane',          :src => 'Flip4Mac WMV 2.4.4.2.dmg'
  app 'Silverlight.plugin',             :src => 'Flip4Mac WMV 2.4.4.2.dmg'
  app 'GlimmerBlocker.prefPane',        :src => 'GlimmerBlocker-1.4.16.dmg'
  app 'googletalkbrowserplugin.plugin', :src => 'GoogleVoiceAndVideoSetup.dmg'
  app 'OpenDNS Updater.app',            :src => 'OpenDNS-Updater-Mac-3.0.zip'
  app 'Satellite Eyes.app',             :src => 'satellite-eyes-head.zip'
  app 'Skype.app',                      :src => 'Skype_5.7.0.1130.dmg'
  app 'SymbolicLinker.service',         :src => 'SymbolicLinker2.0v3.dmg'
  app 'Touvaly.app',                    :src => 'Touvaly.dmg'

  # Music
  app 'Soundflowerbed.app',             :src => 'Soundflower-1.6.2.1.dmg'
  app 'Smutefy.app',                    :src => 'Smutefy.zip'
  app 'Spotify.app',                    :src => 'SpotifyInstaller.zip', :open => true
  app 'YouTube to MP3.app',             :src => 'YouTubeToMP3.dmg'

  # Games
  app 'Steam.app',                      :src => 'steam.dmg'
  app 'World of Goo.app',               :src => 'WorldOfGoo.1.30.dmg'

  app 'LogMeIn.plugin', :url => 'https://secure.logmein.com/central/Central.aspx'

  app 'Sparrow.app', :url => 'sparrow/id417250177'

  app 'MockSmtp.app',       :url => 'mocksmtp/id423535515'
  app 'Cobook.app',         :url => 'cobook/id525225808'
  app 'DragonDrop.app',     :url => 'dragondrop/id499148234'
  app 'Reeder.app',         :url => 'reeder/id439845554'
  app 'Droplr.app',         :url => 'droplr/id498672703'
  app 'Growl.app',          :url => 'growl/id467939042'
  app 'Skitch.app',         :url => 'skitch/id425955336'
  app 'The Unarchiver.app', :url => 'the-unarchiver/id425424353'
  app 'Twitter.app',        :url => 'twitter/id409789998'
  app 'iPhoto.app',         :url => 'iphoto/id408981381'

end


if ask "Sync ~/Library with Dropbox?"
  sync_library :home => '~/Library', :cloud => '~/Dropbox/Library'
end


if ask "Apply system preferences?"

  set 'Disable menu bar transparency', 
    'defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool true'

  set 'Hide remaining battery time; hide percentage', 
    'defaults write com.apple.menuextra.battery ShowPercent -string "NO"',
    'defaults write com.apple.menuextra.battery ShowTime -string "NO"'

  set 'Expand save panel by default', 
    'defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true'

  set 'Expand print panel by default', 
    'defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true'

  set 'Disable the "Are you sure you want to open this application?" dialog', 
    'defaults write com.apple.LaunchServices LSQuarantine -bool false'

  # Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
  set 'Display ASCII control characters using caret notation in standard text views', 
    'defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true'

  set 'Disable opening and closing window animations', 
    'defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false'

  set 'Increase window resize speed for Cocoa applications (default: 0.2)', 
    'defaults write NSGlobalDomain NSWindowResizeTime -float 0.001'

  set 'Enable subpixel font rendering on non-Apple LCDs (default: 0)', 
    'defaults write NSGlobalDomain AppleFontSmoothing -int 2'

  # set 'Enable tap to click (Trackpad) for this user and for the login screen', 
  #   'defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true', 
  #   'defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1', 
  #   'defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1'

  set 'Disable window animations and Get Info animations in Finder', 
    'defaults write com.apple.finder DisableAllAnimations -bool true'

  set 'Show all filename extensions in Finder', 
    'defaults write NSGlobalDomain AppleShowAllExtensions -bool true'

  set 'Show status bar in Finder', 
    'defaults write com.apple.finder ShowStatusBar -bool true'

  set 'Disable disk image verification', 
    'defaults write com.apple.frameworks.diskimages skip-verify -bool true', 
    'defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true', 
    'defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true'

  set 'Display full POSIX path as Finder window title', 
    'defaults write com.apple.finder _FXShowPosixPathInTitle -bool true'

  set 'Avoid creating .DS_Store files on network volumes', 
    'defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true'

  set 'Disable the warning when changing a file extension', 
    'defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false'

  # set 'Show item info below desktop icons', 
  #   '/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist'

  # set 'Enable snap-to-grid for desktop icons', 
  #   '/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist'

  set 'Disable the warning before emptying the Trash', 
    'defaults write com.apple.finder WarnOnEmptyTrash -bool false'

  set 'Empty Trash securely by default', 
    'defaults write com.apple.finder EmptyTrashSecurely -bool true'

  set 'Show the ~/Library folder', 
    'chflags nohidden ~/Library'

  set 'Remove the auto-hiding Dock delay', 
    'defaults write com.apple.Dock autohide-delay -float 0'

  set 'Remove the animation when hiding/showing the Dock', 
    'defaults write com.apple.dock autohide-time-modifier -float 0'

  set 'Enable the 2D Dock', 
    'defaults write com.apple.dock no-glass -bool true'

  set 'Automatically hide and show the Dock', 
    'defaults write com.apple.dock autohide -bool true'

  set 'Make Dock icons of hidden applications translucent', 
    'defaults write com.apple.dock showhidden -bool true'

  set 'Enable iTunes track notifications in the Dock', 
    'defaults write com.apple.dock itunes-notifications -bool true'

  set 'Disable shadow in screenshots', 
    'defaults write com.apple.screencapture disable-shadow -bool true'

  set "Disable Safari's thumbnail cache for History and Top Sites", 
    'defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2'

  set "Enable Safari's debug menu", 
    'defaults write com.apple.Safari IncludeInternalDebugMenu -bool true'

  set "Make Safari's search banners default to Contains instead of Starts With", 
    'defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false'

  set 'Only use UTF-8 in Terminal.app', 
    'defaults write com.apple.terminal StringEncodings -array 4'

  # Restart affected apps
  set 'Kill affected applications', 
    'for app in Finder Dock Mail Safari iTunes iCal Address\ Book SystemUIServer; do killall "$app" > /dev/null 2>&1; done'

  # Notify when finished
  puts blue("\n...done. Note that some of these changes require a logout/restart to take effect.")

end
