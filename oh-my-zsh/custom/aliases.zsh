# If on a Mac, use MacVim
platform=`uname`
if [[ "$platform" == 'Darwin' ]]; then

#   # Use MacVim's binary for terminal vim
#   alias vim='/Applications/MacVim.app/Contents/MacOS/Vim -p'
#
#   # Typing gvim/mvim in terminal will now launch MacVim
#   alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g -p'
#   alias mvim='/Applications/MacVim.app/Contents/MacOS/Vim -g -p'

  # Remove dupes in Open With
  alias openwithfix='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user;killall Finder'

  # Restart logmein server
  alias logmeinfix='/Library/Application\ Support/LogMeIn/preupdate && sudo /Library/Application\ Support/LogMeIn/postupdate'
fi

# Make these commands ask before clobbering a file. Use -f to override.
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# Use human-readable filesizes
alias du="du -h"
alias df="df -h"
alias df="df -h"

# requires osx plugin
alias ql="quick-look"

# Quick access to dotfiles
alias dotfiles='cd $HOME/.dotfiles; ls -lh'

# git graph
# alias gg='git log --graph --abbrev-commit --decorate --all --oneline --color'
alias gg="git log --graph --abbrev-commit --decorate --all --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'"

# bundler laziness
alias be="bundle exec"
alias bi="bundle install --path vendor/bundle"
alias bb="bundle install --binstubs"
alias bl="bundle list"
alias bs="bundle show"
alias bu="bundle update"
alias bp="bundle package"

# python
alias server="python -m SimpleHTTPServer"

# nterchange laziness
alias n="nterchange"

# Edit the smb.conf
alias smb='sudo vim /opt/local/etc/samba3/smb.conf'

