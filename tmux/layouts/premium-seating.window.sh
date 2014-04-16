# Set window root path. Default is `$session_root`.
# Must be called before `new_window`.
window_root "~/code/calgarystampede/premium_seating"

# Create new window
new_window "premium-seating"

# Split window into panes
split_v 25
split_h 60
split_h 30

# Vim
run_cmd "v -c 'colorscheme solarized' Gemfile" 1
send_keys ",d" 1

# Command line
run_cmd "git status" 2 

# Rails console
run_cmd "rails console" 3

# Web server
run_cmd "passenger stop -p 5000" 4
run_cmd "foreman start" 4

# Set active pane
select_pane 1

