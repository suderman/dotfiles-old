# 2014 Jon Suderman
# https://github.com/suderman/dotfiles/

# Relative bin
export MYPATH="bin"

# Home bin
if [ -d $HOME/bin ]; then
  export MYPATH="$MYPATH:$HOME/bin"
fi

# User bin for OS X
if [ -d $HOME/.osx/bin ]; then
  export MYPATH="$MYPATH:$HOME/.osx/bin"
fi

# User bin for Linux
if [ -d $HOME/.linux/bin ]; then
  export MYPATH="$MYPATH:$HOME/.linux/bin"
fi

# vim bin
if [ -d $HOME/.vim/bin ]; then
  export MYPATH="$MYPATH:$HOME/.vim/bin"
fi

# linuxbrew
if [ -d ~/.linuxbrew ]; then
  export MYPATH="$MYPATH:$HOME/.linuxbrew/bin"
  export LD_LIBRARY_PATH="$HOME/.linuxbrew/lib:$LD_LIBRARY_PATH"
fi

# usr local bin (mostly homebrew)
export MYPATH="$MYPATH:/usr/local/bin:/usr/local/sbin"

# tmuxifier
if [ -d ~/.tmuxifier ]; then
  export MYPATH="$MYPATH:$HOME/.tmuxifier/bin"
fi

# node path
if [ -d /usr/local/lib/node_modules ]; then
  export NODE_PATH="/usr/local/lib/node_modules"
  export MYPATH="$MYPATH:/usr/local/share/npm/bin"
fi

# PHP path
if [ -d /usr/local/Cellar/php/5.3.10/bin ]; then
  export MYPATH="$MYPATH:/usr/local/Cellar/php/5.3.10/bin"
fi

# Heroku Toolbelt
if [ -d /usr/local/heroku/bin ]; then
  export MYPATH="$MYPATH:/usr/local/heroku/bin"
fi

# Append original path
export PATH="$MYPATH:$PATH"

# Man path
export MANPATH="$HOME/local/share:/usr/local/man:$MANPATH"

