# If on a Mac, use MacVim
platform=`uname`
if [[ "$platform" == 'Darwin' ]]; then

  # Use MacVim's binary for terminal vim
  alias vim='/Applications/MacVim.app/Contents/MacOS/Vim -p'

  # Typing gvim/mvim in terminal will now launch MacVim
  alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g -p'
  alias mvim='/Applications/MacVim.app/Contents/MacOS/Vim -g -p'

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

# bundler laziness
alias be="bundle exec"
alias bi="bundle install --path vendor/bundle"
alias bb="bundle install --binstubs"
alias bl="bundle list"
alias bs="bundle show"
alias bu="bundle update"
alias bp="bundle package"

# rbenv laziness
alias rb="rbenv"
alias rbi="rbenv install"
alias rbr="rbenv rehash"
alias rbl="rbenv local"
alias rbg="rbenv global"
alias rbs="rbenv shell"
alias rbu="rbenv shell --unset"
alias rbv="rbenv versions"

# nterchange laziness
alias n="nterchange"

# Watch current directory and compile coffeescript
alias coffeejs='coffee -cw ./*.coffee'

# Watch and compile coffeescript and sass files
alias sasswatch='sass --watch public_html/stylesheets/:public_html/stylesheets'
alias coffeewatch='coffee -cwl public_html/javascripts/*.coffee'

# The command-line tool uses a lame per-file watching API from EventMachine and runs out of open file limit on large projects. In Chrome, this looks like a broken connection immediately after you connect. In Safari, this looks like a crash (since Safari crashes if websocket is disconnected during handshake).
alias livereload='ulimit -n 4096;livereload'

# Edit the smb.conf
alias smb='sudo vim /opt/local/etc/samba3/smb.conf'
