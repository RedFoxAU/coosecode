#!/bin/bash

# Define variables
SMB_SHARE="//192.168.1.100/backup"  # Replace with your SMB share
SMB_USERNAME="your_username"  # SMB username
SMB_PASSWORD="your_password"  # SMB password
MOUNT_POINT="/mnt/network_host_backup"  # Local mount point
BACKUP_SRC="/etc"  # Source directory to backup

# Function to ensure cifs-utils is installed
ensure_cifs_utils() {
    echo "Checking if cifs-utils is installed..."
    if ! dpkg -l | grep -q cifs-utils; then
        echo "cifs-utils is not installed. Installing it now..."
        apt update && apt install -y cifs-utils
        if [[ $? -eq 0 ]]; then
            echo "cifs-utils installed successfully."
        else
            echo "Failed to install cifs-utils. Please check your network or package manager."
            exit 1
        fi
    else
        echo "cifs-utils is already installed."
    fi
}

# Function to create the mount point if it doesn't exist
ensure_mount_point() {
    if [[ ! -d "$MOUNT_POINT" ]]; then
        echo "Mount point $MOUNT_POINT does not exist. Creating it..."
        mkdir -p "$MOUNT_POINT"
        if [[ $? -eq 0 ]]; then
            echo "Mount point created successfully."
        else
            echo "Failed to create mount point. Please check permissions."
            exit 1
        fi
    else
        echo "Mount point $MOUNT_POINT already exists."
    fi
}

# Function to mount the SMB share
mount_smb_share() {
    echo "Attempting to mount the SMB share..."
    
    # Check if the share is already mounted
    if ! mount | grep "$MOUNT_POINT" > /dev/null; then
        echo "Mounting SMB share..."
        mount -t cifs "$SMB_SHARE" "$MOUNT_POINT" -o username="$SMB_USERNAME",password="$SMB_PASSWORD"
        
        # Verify if the mount was successful
        if mount | grep "$MOUNT_POINT" > /dev/null; then
            echo "SMB share mounted successfully at $MOUNT_POINT."
        else
            echo "Failed to mount the SMB share. Please check your credentials and network connection."
            exit 1
        fi
    else
        echo "SMB share is already mounted at $MOUNT_POINT."
    fi
}

# Function to create the backup directory on the SMB share
create_backup_directory() {
    TIMESTAMP=$(date +%Y%m%d%H%M)
    HOSTNAME=$(hostname)
    BACKUP_DIR="$MOUNT_POINT/$TIMESTAMP-$HOSTNAME"

    echo "Creating backup directory at $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"
}

# Function to perform the backup
perform_backup() {
    echo "Starting backup from $BACKUP_SRC..."
    
    # Perform the backup (copy /etc to the backup directory)
    cp -r "$BACKUP_SRC" "$BACKUP_DIR"
    
    # Check if the backup was successful
    if [[ $? -eq 0 ]]; then
        echo "Backup completed successfully to $BACKUP_DIR."
    else
        echo "Error occurred during the backup process."
        exit 1
    fi
}

# Function to list the backup folder stats (size, file count)
list_backup_stats() {
    echo "Listing stats for backup directory $BACKUP_DIR..."
    
    # Get total size of the backup directory
    du -sh "$BACKUP_DIR"
    
    # Get the count of files and directories in the backup folder
    echo "Total files: $(find "$BACKUP_DIR" -type f | wc -l)"
    echo "Total directories: $(find "$BACKUP_DIR" -type d | wc -l)"
}

# Main script execution
echo "Starting the backup script..."

# 1. Ensure cifs-utils is installed
ensure_cifs_utils

# 2. Ensure the mount point exists
ensure_mount_point

# 3. Mount the SMB share
mount_smb_share

# 4. Create the backup directory on the SMB share
create_backup_directory

# 5. Perform the backup
perform_backup

# 6. List backup stats (size, file count)
list_backup_stats

echo "Backup script completed. SMB share remains mounted."
