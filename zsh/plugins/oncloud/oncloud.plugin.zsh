# Automagic oncloud!
oncloud () {

  # If there's a site .bridge_keys file, use that.
  if [ -f "$PWD/.bridge_keys" ]; then
    echo "Site .bridge_keys found."
    oncloud_key=`head -1 "$PWD/.bridge_keys"`
  
  # Otherwise, look for the user .bridge_keys file
  else
    if [ -f "$HOME/.bridge_keys" ]; then
      echo "User .bridge_keys found."
      oncloud_key=`head -1 "$HOME/.bridge_keys"`
      echo "Missing site .bridge_keys. You can get one from http://www.oncloud.org/ and set it with this command:"
      echo "echo 'KEY-GOES-HERE' >> $PWD/.bridge_keys"      
    else
      echo "Missing .bridge_keys file. Go get one from http://www.oncloud.org/"
      echo "\nYou can set one for your user account with this command:"
      echo "echo 'KEY-GOES-HERE' >> $HOME/.bridge_keys"
      echo "\nOr you can set one for this site with this command:"
      echo "echo 'KEY-GOES-HERE' >> $PWD/.bridge_keys"
      return
    fi
  fi

  # Ensure bundler gem is installed
  check_bundler=`gem list bundler`
  if [ -z "$check_bundler" ]; then
    echo "Missing bundler gem. Can your app even run yet?"
    return
  fi

  # Check if rack-bridge gem is in Gemfile
  if grep -q 'rack-bridge' "$PWD/Gemfile"; then

    # rack-bridge found in Gemfile, now check if it's installed
    check_rackbridge=`gem list rack-bridge`
    if [ -z "$check_rackbridge" ]; then
      echo "Missing rack-bridge gem. Installing..."
      bundle install
    else
      echo "Found rack-bridge gem."
    fi

  # Add rack-bridge to Gemfile and install
  else
    echo "Missing rack-bridge gem. Updating Gemfile and installing..."
    echo "\ngem 'rack-bridge', :group => :development" >> Gemfile
    bundle install
  fi

  # Get host from key
  oncloud_host=`echo ${oncloud_key##*:}`

  echo "Launching browser window."
  open "http://$oncloud_host/"

  echo "Running server..."
  # Rails 3
  if [ -f ./script/rails ]; then 
    rails server Bridge -b $oncloud_host
  # Rails 2
  elif [ -f ./script/server ]; then 
    script/server Bridge -b $oncloud_host
  # Rack
  else
    rackup -s Bridge -o $oncloud_host
  fi
}