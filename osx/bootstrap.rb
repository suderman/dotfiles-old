#!/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby
# /usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/suderman/dotfiles/master/osx/bootstrap.rb)"

# URL to git installer
git = "https://dl.dropbox.com/s/y80vt8720xrv5h0/git.pkg"

# Install git
system "curl #{git} -o /tmp/git.pkg"
system "sudo installer -pkg /tmp/git.pkg -target /"
system "source /etc/profile"

# Install dotfiles
system "git clone https://suderman@github.com/suderman/dotfiles.git ~/.dotfiles"
system "cd ~/.dotfiles && ./install.rb"
system "source ~/.zshrc"

# OS X settings, library syncing and apps
system "~/.osx/install.rb"
