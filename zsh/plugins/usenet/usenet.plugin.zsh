# Install usenet apps
#
# cd /tmp && curl http://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz -o cheetah.tar.gz
# tar -zxvf cheetah.tar.gz && cd Cheetah-2.4.4
# sudo python setup.py install
#
# mkdir -p /usr/local/usenet && cd /usr/local/usenet
# git clone git://github.com/sabnzbd/sabnzbd.git
# git clone git://github.com/midgetspy/Sick-Beard.git
# git clone git://github.com/RuudBurger/CouchPotato.git
# git clone git://github.com/rembo10/headphones.git

# launch usenet apps inside a tmux session!
usenet () {

  # the name of my usenet tmux session
  sn=usenet

  # location for some folders
  bin=/usr/local/usenet
  etc=$HOME/Dropbox/Library/etc

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
  tmux new-window -t $sn -n sabnzbd     "python $bin/sabnzbd/SABnzbd.py --config-file $etc/sabnzbd/sabnzbd.ini --server localhost:8080 --browser 0; bash -i"
  tmux new-window -t $sn -n sickbeard   "python $bin/Sick-Beard/SickBeard.py --datadir=$etc/sickbeard --port=8081 --nolaunch; bash -i"
  tmux new-window -t $sn -n couchpotato "python $bin/CouchPotato/CouchPotato.py --datadir=$etc/couchpotato --port=8082 --nolaunch; bash -i"
  tmux new-window -t $sn -n headphones  "python $bin/headphones/Headphones.py --datadir=$etc/headphones --port=8083 --nolaunch; bash -i"

  # Focus on the first window
  tmux select-window -t $sn:1
  tmux attach -t $sn
}
