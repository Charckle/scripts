#!/bin/bash

# Function to check if a command is available
check_command() {
    command -v "$1" > /dev/null 2>&1
}

# Function to install a package if not available
install_package() {
    if ! check_command "$1"; then
        echo "Command ${1} not found. Installing..."
        echo "Please enter your sudo password if prompted."
        sudo apt-get install -y "${1}"  # Adjust for your package manager
    fi
}

# Check and install nmap and iperf3
install_package "tmux"
install_package "fzf"
install_package "net-tools"

# give tmux colors
echo "set -g default-terminal 'screen-256color'" > ~/.tmux.conf


# fzf as your bash search solution

BASH_RC_LOC=~/.bashrc

cat << 'EOF' >> "${BASH_RC_LOC}"

# Add fzf key bindings
source /usr/share/doc/fzf/examples/key-bindings.bash

# Use fzf to search bash history
_fzf_history_completion() {
  local selected_command
  selected_command=$(history | fzf --tac +s --ansi +m -n2..,.. --no-sort | sed 's/ *[0-9]* *//')
  READLINE_LINE=${READLINE_LINE:+${READLINE_LINE% *} }$selected_command
  READLINE_POINT=${#READLINE_LINE}
}
bind -x '"\C-r": _fzf_history_completion'
EOF


echo "Fzf bindings appended to ~/.bashrc. Run 'source ~/.bashrc' to get it working."

echo "alias plac='du -h --max-depth=1 | sort -hr'"
echo "Alias 'plac' has been added to the .bashrc file. this command checks the size of current folders"

echo "run 'source ~/.bashrc' to update your bash commands"
