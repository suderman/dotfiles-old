# Install usenet apps
#
# cd /tmp && curl http://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz -o cheetah.tar.gz
# tar -zxvf cheetah.tar.gz && cd Cheetah-2.4.4
# sudo python setup.py install
#
# mkdir -p /usr/local/usenet && cd /usr/local/usenet
# git clone git://github.com/sabnzbd/sabnzbd.git
# git clone git://github.com/midgetspy/Sick-Beard.git
# git clone git://github.com/RuudBurger/CouchPotatoServer.git
# git clone git://github.com/rembo10/headphones.git

# location for some folders
bin=/usr/local/usenet
etc=$HOME/Dropbox/Library/etc

# How these python apps should be run
sabnzbd="python $bin/sabnzbd/SABnzbd.py --config-file $etc/sabnzbd/sabnzbd.ini --server 10.0.0.8:8080 --browser 0"
sickbeard="python $bin/Sick-Beard/SickBeard.py --datadir=$etc/sickbeard --port=8081 --nolaunch"
couchpotato="python $bin/CouchPotatoServer/CouchPotato.py --data_dir=$etc/couchpotato"
headphones="python $bin/headphones/Headphones.py --datadir=$etc/headphones --port=8083 --nolaunch"

# Shortcuts to launching these lovely python apps
alias sabnzbd="$sabnzbd"
alias sickbeard="$sickbeard"
alias couchpotato="$couchpotato"
alias headphones="$headphones"


# launch usenet apps inside a tmux session!
usenet () {

  # the name of my usenet tmux session
  sn=usenet

  # if the session is already running, just attach to it.
  tmux has-session -t $sn
  if [ $? -eq 0 ]; then
      echo "Session $sn already exists. Attaching."
      sleep 1
      tmux attach -t $sn
      exit 0;
  fi

  # create a new session and detach from it
  tmux new-session -d -s $sn
  tmux rename-window -t $sn:1 zsh

  # Open new windows with usenet apps
  tmux new-window -t $sn -n sabnzbd     "$sabnzbd; zsh -i"
  tmux new-window -t $sn -n sickbeard   "$sickbeard; zsh -i"
  tmux new-window -t $sn -n couchpotato "$couchpotato; zsh -i"
  tmux new-window -t $sn -n headphones  "$headphones; zsh -i"

  # Focus on the first window
  tmux select-window -t $sn:1
  tmux attach -t $sn
}
