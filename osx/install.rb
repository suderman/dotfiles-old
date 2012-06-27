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

  # Install installion
  brew "installion", :tap => "suderman/suds"

  # Install node & npm
  brew "node"
  command "npm", :command => "curl http://npmjs.org/install.sh | sh"

  install 'Dropbox.app', :source => '98shr7bfcuoo39o/Dropbox 1-2.4.7.dmg' do
  end

  install 'llvm-gcc', :source => '94pqy3oq1zt9xso/cltools_lion_latemarch12.dmg'
  install 'gcc', :source => 'zmlm47fmbqcnwl7/GCC-10.7-v2.pkg'

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
  `export INSTALLION_SOURCE=~/Dropbox/Installers`

  # Productivity
  install '1Password.app',                  :source => '1Password-3.8.19.zip'
  install 'Alfred.app',                     :source => 'alfred_1.2_220.dmg'
  install 'AppCleaner.app',                 :source => 'AppCleaner_2.1.zip'
  install 'Choosy.prefPane',                :source => 'choosy_1.0.3.zip'
  install 'CandyBar.app',                   :source => 'CandyBar 3.3.3.zip'
  install 'Fantastical.app',                :source => 'Fantastical_1.3.1.zip'
  install 'Fluid.app',                      :source => 'Fluid_1.4.zip'
  install 'HyperDock.prefpane',             :source => 'HyperDock.dmg'
  install 'KeyBindingsEditor.app',          :source => 'KeyBindingsEditor.dmg'
  install 'Keyboard Maestro.app',           :source => 'keyboardmaestro-53.zip'
  install 'Launchpad-Control.prefPane',     :source => 'Launchpad-Control.zip'

  # Media
  install 'Air Video Server.app',           :source => 'Air+Video+Server+2.4.3.dmg'
  install 'HandBrake.app',                  :source => 'HandBrake-0.9.6-MacOSX.6_GUI_x86_64.dmg'
  install 'Newzbin2 Client.app',            :source => 'Newzbin2Client-1.1.0.0.345.intel.app.zip'
  install 'PS3 Media Server.app',           :source => 'pms-macosx-1.52.1.dmg'
  install 'SABnzbd.app',                    :source => 'SABnzbd-0.6.15-osx.dmg'
  install 'Transmission.app',               :source => 'Transmission-2.52.dmg'
  install 'SMBUp.app',                      :source => 'SMBUp.1.4.zip'
  install 'VLC.app',                        :source => 'vlc-2.0.1.dmg'

  # Development
  install 'Google Chrome Canary.app',       :source => 'GoogleChromeCanary.dmg'
  install 'Firefox.app',                    :source => 'Firefox 13.0.dmg'
  install 'GitHub.app',                     :source => 'mac_GitHub for Mac 1.2.8.zip'
  install 'iTerm.app',                      :source => 'iTerm2-1_0_0_20120203.zip'
  install 'Paparazzi!.app',                 :source => 'Paparazzi! 0.5b6.dmg'
  install 'Sequel Pro.app',                 :source => 'Sequel_Pro_0-1.9.9.1.dmg'
  install 'TextMate.app',                   :source => 'TextMate_1.5.10_r1631.zip'
  install 'TextWrangler.app',               :source => 'TextWrangler_4.0.1.dmg'
  install 'TrackRecord 2.app',              :source => 'TrackRecord2.zip'
  install 'Transmit.app',                   :source => 'Transmit 4.1.9.zip'
  install 'VMware Fusion.app',              :source => 'VMware-Fusion-4-1.1.1-536016-light.dmg' do
    `rm -rf "/Applications/Getting Started.app"`
    `rm -rf "/Applications/Double-click to upgrade from VMware Fusion 3.app"`
  end

  # Creative
  install 'Scrivener.app',                  :source => 'Scrivener.dmg'
  install 'Aeon Timeline.app',              :source => 'AeonTimeline_1_0_0.dmg'
  install 'nvALT.app',                      :source => 'nvALT.zip'
  install 'Microsoft Word.app',             :source => 'X17-45975-1.dmg'
  install 'Adobe Photoshop CS6.app',        :source => 'Photoshop_13_LS16-1.dmg', :open => true
  install 'Adobe Fireworks CS6.app',        :source => 'Fireworks_12_LS16.dmg', :open => true

  # Utilities
  install 'MadCatzCyborgRAT.prefpane',      :source => 'CyborgRAT-1.1.28.zip'
  install 'Flash Player.prefPane',          :source => 'install_flash_player_osx.dmg'
  install 'Flip4Mac WMV.prefPane',          :source => 'Flip4Mac WMV 2.4.4.2.dmg'
  install 'Silverlight.plugin',             :source => 'Flip4Mac WMV 2.4.4.2.dmg'
  install 'GlimmerBlocker.prefPane',        :source => 'GlimmerBlocker-1.4.16.dmg'
  install 'googletalkbrowserplugin.plugin', :source => 'GoogleVoiceAndVideoSetup.dmg'
  install 'OpenDNS Updater.app',            :source => 'OpenDNS-Updater-Mac-3.0.zip'
  install 'Satellite Eyes.app',             :source => 'satellite-eyes-head.zip'
  install 'Skype.app',                      :source => 'Skype_5.7.0.1130.dmg'
  install 'SymbolicLinker.service',         :source => 'SymbolicLinker2.0v3.dmg'
  install 'Touvaly.app',                    :source => 'Touvaly.dmg'

  # Music
  install 'Soundflowerbed.app',             :source => 'Soundflower-1.6.2.1.dmg'
  install 'Smutefy.app',                    :source => 'Smutefy.zip'
  install 'Spotify.app',                    :source => 'SpotifyInstaller.zip', :open => true
  install 'YouTube to MP3.app',             :source => 'YouTubeToMP3.dmg'

  # Games
  install 'Steam.app',                      :source => 'steam.dmg'
  install 'World of Goo.app',               :source => 'WorldOfGoo.1.30.dmg'

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
