# 2014 Jon Suderman
# https://github.com/suderman/dotfiles/

# Change directory using ranger
function ranger-cd() {
  tempfile='/tmp/chosendir'
  ranger --choosedir="$tempfile" "${@:-$(pwd)}" < $TTY
  test -f "$tempfile" &&
  if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
      cd -- "$(cat "$tempfile")"
  fi
  rm -f -- "$tempfile"
  ls -lah
}
ranger-cd-wrapper() {
  ranger-cd
  ls -lah
}

# This binds Ctrl-O to ranger-cd:
zle -N ranger-cd
bindkey '^o' ranger-cd


# # Automatically do an ls after each cd
# cd() {
#   if [ -n "$1" ]; then
#     builtin cd "$@" && ls
#   else
#     builtin cd ~ && ls
#   fi
# }

# Change group to nonfiction and fix permissions
fixperm() {
  sudo chown -R :nonfiction ./*
  sudo chmod -R 775 ./*
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

