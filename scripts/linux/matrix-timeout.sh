#!/bin/bash
# Disable SIGINT (CTRL+C) to prevent breakouts during the screensaver.
trap '' SIGINT

# Run cmatrix (the screensaver).
cmatrix -b

clear

# Instead of an infinite loop without conditions, we add a timeout.
while true; do
    # Start /bin/login in background
    /bin/login &
    login_pid=$!
    
    # Wait for user login or timeout after 60 seconds
    timeout=60
    elapsed=0
    while kill -0 "$login_pid" 2>/dev/null && [ $elapsed -lt $timeout ]; do
        sleep 1
        elapsed=$((elapsed + 1))
    done
    
    # If the login prompt is still running after 60 seconds, kill it.
    if kill -0 "$login_pid" 2>/dev/null; then
        kill "$login_pid"
        wait "$login_pid" 2>/dev/null
    fi
    # Optional pause before repeating
    sleep 1
done
