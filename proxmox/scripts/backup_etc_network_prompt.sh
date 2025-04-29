#!/bin/bash

# Setup Samba, add share
#/etc/samba/smb.conf
#[share]
#   path = /rpool/data/share
#   browseable = yes
#   writable = yes
#   valid users = root, audino
#   create mask = 0770
#   directory mask = 0770
#   force user = debian
#   force group = audino
#   guest ok = no
#   read only = no
#   follow symlinks = yes    

# create script
# nano backup_host_network_prompt.sh
# chmod +x backup_host_network_prompt.sh
# run script
# ./backup_host_network_prompt.sh

# Log file
LOG_FILE="/var/log/network_backup.log"
ERRORS_FILE="/var/log/network_backup_errors.log"

# Function to log messages to the log file
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Function to log error messages to the errors log file
log_error() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: $1" >> "$ERRORS_FILE"
}

# Function to prompt for SMB credentials and mount the share
mount_smb_share() {
    echo "Enter SMB Username:"
    read -r SMB_USERNAME
    echo "Enter SMB Password:"
    read -s SMB_PASSWORD

    MOUNT_POINT="/mnt/network_host_backup"
    SMB_SERVER="//10.192.134.218/share"

    log_message "Attempting to mount SMB share: $SMB_SERVER"

    # Ensure the mount point directory does not exist from previous mounts
    if mountpoint -q "$MOUNT_POINT"; then
        echo "Unmounting previous SMB share..."
        umount "$MOUNT_POINT"
        if [ $? -eq 0 ]; then
            log_message "Previous SMB share unmounted successfully."
        else
            log_message "Failed to unmount previous SMB share."
            echo "Failed to unmount previous SMB share. Check logs for details."
            return 1
        fi
    fi

    # Remove the mount point directory if it exists
    if [ -d "$MOUNT_POINT" ]; then
        echo "Removing old mount point directory..."
        rmdir "$MOUNT_POINT"
        if [ $? -eq 0 ]; then
            log_message "Old mount point directory removed successfully."
        else
            log_message "Failed to remove old mount point directory."
            echo "Failed to remove old mount point directory. Check logs for details."
        fi
    fi

    # Recreate the mount point directory
    echo "Creating new mount point directory: $MOUNT_POINT"
    mkdir -p "$MOUNT_POINT"
    
    # Attempt to mount the SMB share
    echo "Mounting SMB share..."
    mount -t cifs "$SMB_SERVER" "$MOUNT_POINT" -o username="$SMB_USERNAME",password="$SMB_PASSWORD"
    
    if [ $? -eq 0 ]; then
        log_message "SMB share mounted successfully."
        echo "SMB share mounted successfully!"
    else
        log_message "Failed to mount SMB share: $SMB_SERVER"
        echo "Failed to mount SMB share. Check logs for details."
        return 1
    fi
}

# Function to perform the backup using rsync
perform_backup() {
    BACKUP_DIR="$MOUNT_POINT/$(date +%Y%m%d%H%M)-ictstore"
    echo "Creating backup directory: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"

    log_message "Backup started from /etc to $BACKUP_DIR"
    
    # Create a temporary file to track failed files
    FAILED_FILES="/tmp/failed_files.txt"
    > "$FAILED_FILES"  # Clear any previous failed file entries
    
    # Perform the backup (rsync instead of cp)
    rsync -av --progress /etc/ "$BACKUP_DIR" 2>&1 | tee /tmp/rsync_output.log | grep -i 'failed\|error' >> "$FAILED_FILES"

    if [ $? -eq 0 ]; then
        log_message "Backup completed successfully from /etc to $BACKUP_DIR."
        echo "Backup completed successfully!"
    else
        log_message "Backup failed from /etc to $BACKUP_DIR."
        echo "Backup failed. Check logs for details."
        exit 1
    fi

    # Check if there were failed files and log them
    if [ -s "$FAILED_FILES" ]; then
        log_message "Failed files during backup:"
        cat "$FAILED_FILES" | while read -r line; do
            log_error "Failed to backup file: $line"
        done
        echo "There were some files that failed to back up. Check the log for details."
        
        # Echo the failed files to the screen
        echo "Failed files during backup:"
        cat "$FAILED_FILES"
    else
        echo "No errors during backup."
    fi
}

# Function to unmount the SMB share and remove the mount point directory
umount_smb_share() {
    echo "Unmounting SMB share..."
    umount "$MOUNT_POINT"
    
    if [ $? -eq 0 ]; then
        log_message "SMB share unmounted successfully."
        echo "SMB share unmounted successfully!"
    else
        log_message "Failed to unmount SMB share."
        echo "Failed to unmount SMB share. Check logs for details."
        exit 1
    fi

    # Remove the mount point directory after unmounting
    echo "Removing mount point directory: $MOUNT_POINT"
    rmdir "$MOUNT_POINT"
    if [ $? -eq 0 ]; then
        log_message "Mount point directory removed successfully."
        echo "Mount point directory removed successfully."
    else
        log_message "Failed to remove mount point directory."
        echo "Failed to remove mount point directory. Check logs for details."
    fi
}

# Function to write a summary to a log file
write_summary() {
    SUMMARY_FILE="$MOUNT_POINT/backup_summary.txt"
    echo "Writing summary to $SUMMARY_FILE"
    log_message "Writing backup summary to $SUMMARY_FILE"

    echo "Backup Summary:" > "$SUMMARY_FILE"
    echo "=================" >> "$SUMMARY_FILE"
    echo "SMB Server: $SMB_SERVER" >> "$SUMMARY_FILE"
    echo "SMB Username: $SMB_USERNAME" >> "$SUMMARY_FILE"
    echo "Backup Directory Created: $BACKUP_DIR" >> "$SUMMARY_FILE"
    echo "Backup Status: Success" >> "$SUMMARY_FILE"
    echo "Unmount Status: Success" >> "$SUMMARY_FILE"
    echo "Date of Backup: $(date)" >> "$SUMMARY_FILE"

    log_message "Backup summary written to $SUMMARY_FILE"
    echo "Summary written to $SUMMARY_FILE"
}

# Main script
echo "Starting network backup script..."
log_message "Starting network backup script."

# Mount SMB share
mount_smb_share || { log_message "Failed to mount SMB share. Exiting..."; echo "Failed to mount SMB share. Exiting..."; exit 1; }

# Perform the backup
perform_backup

# Unmount the SMB share and remove the mount point directory
umount_smb_share

# Write summary to a file
write_summary

log_message "Script completed successfully."
echo "Script completed successfully!"
