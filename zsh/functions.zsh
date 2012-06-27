#Automatically do an ls after each cd
cd() {
  if [ -n "$1" ]; then
    builtin cd "$@" && ls
  else
    builtin cd ~ && ls
  fi
}

# Convert to from Unicode to ASCII
fixenc() {
  if [ -n "$1" ]; then
    before=`file "$@"`
    iconv --from-code UTF-8 --to-code US-ASCII -c "$@" > fixenctmpfile
    rm -f "$@"
    mv fixenctmpfile "$@"
    after=`file "$@"`
    echo "$before -----> $after"
  else
    echo "You gotta tell me which file to fix!"
  fi
}

# Change group to nonfiction and fix permissions
fixperm() {
  sudo chown -R :nonfiction ./*
  sudo chmod -R 775 ./*
}

# Working directory for nterchange apps
nwork() {
  mkdir -p "$PWD/working"
  ln -s "$PWD/app" "$PWD/working/app"
  ln -s "$PWD/conf" "$PWD/working/conf"
  ln -s "$PWD/public_html/javascripts" "$PWD/working/javascripts"
  ln -s "$PWD/public_html/stylesheets" "$PWD/working/stylesheets"
  cd "$PWD/working"
}

# Get the permissions of a file
getperms() {

  filels=$(ls -l $1)
  fileperms=$(echo $filels | awk '{print $1}') 
  fileowner=$(echo $filels | awk '{print $3}')
  filegroup=$(echo $filels | awk '{print $4}')

  owner=${fileperms:1:3} 
  group=${fileperms:4:3} 
  other=${fileperms:7:3} 

  echo "file: " $1
  echo "owner("$fileowner"):" $owner 
  echo "group("$filegroup"):" $group 
  echo "others:" $other

  owneroctal=0
  groupoctal=0
  otheroctal=0

  #read bit
  if [ "${owner:0:1}" = "r" ]; then
    let owneroctal=$ownerocatl+4
  fi

  if [ "${owner:1:1}" = "w" ]; then
    let owneroctal=$owneroctal+2
  fi

  if [ "${owner:2:1}" = "x" ]; then
    let owneroctal=$owneroctal+1
  fi

  #write bit
  if [ "${group:0:1}" = "r" ]; then
    let groupoctal=$groupoctal+4;
  fi

  if [ "${group:1:1}" = "w" ]; then
    let groupoctal=$groupoctal+2;
  fi

  if [ "${group:2:1}" = "x" ]; then
    let groupoctal=$groupoctal+1
  fi

  #exec bit
  if [ "${other:0:1}" = "r" ]; then
    let otheroctal=$otheroctal+4;
  fi

  if [ "${other:1:1}" = "w" ]; then
    let otheroctal=$otheroctal+2;
  fi
  if [ "${other:2:1}" = "x" ]; then
    let otheroctal=$otheroctal+1
  fi

  echo $owneroctal$groupoctal$otheroctal
}

# positive integer test (including zero)
function positive_int() { return $(test "$@" -eq "$@" > /dev/null 2>&1 && test "$@" -ge 0 > /dev/null 2>&1); }

# resize the Terminal window
function sizetw() {
   if [[ $# -eq 2 ]] && $(positive_int "$1") && $(positive_int "$2"); then
      printf "\e[8;${1};${2};t"
      return 0
   fi
   return 1
}
