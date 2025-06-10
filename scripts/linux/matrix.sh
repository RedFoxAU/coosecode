#!/bin/bash
# sudo apt install cmatrix -y
# Disable SIGINT (CTRL+C) so that it does not break out during the cmatrix screensaver.
trap '' SIGINT

# Run cmatrix (with -b for bold output)
cmatrix -b

# Clear the screen after cmatrix exits.
clear

# Instead of using exec, use an infinite loop so that if /bin/login gets interrupted, 
# it gets restarted and prevents falling back to a shell.
while true; do
    # Optionally re-disable SIGINT here so that the login prompt isn’t inadvertently interrupted.
    trap '' SIGINT
    /bin/login
    # A small delay can be useful if /bin/login exits repeatedly.
    sleep 1
done
