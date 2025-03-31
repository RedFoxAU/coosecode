#!/bin/bash

# Function to display the spinner
spinner() {
    local pid=$!
    local spin=('|' '/' '-' '\')
    local i=0
    local delay=0.2

    while kill -0 $pid 2>/dev/null; do
        printf "\r[${spin[i]}] Processing..."
        i=$(( (i+1) % 4 ))
        sleep $delay
    done
    printf "\rDone!           \n"  # Clear the spinner and show completion
}

(
#
## ------------------VVVVV Enter Script:
####

    echo "Running..."
    sleep 10

####
## -----------------^^^^^ End Script
#
#
) &  # Runs in background

# Show tha spinner!
spinner

echo "Complete."
