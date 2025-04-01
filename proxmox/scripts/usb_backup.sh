#!/bin/bash

# I save this file in my default directory to backup my PVE host files to USB
# create as anything you want usb_backup.sh then chmod +x usb_backup.sh, then ./usb_backup.sh
# it will force unmount after a warning, aim is that it will backup files regardless
# it will add the usb to fstab to autoload as a storage device as well, but if removed proxmox wont hang for long looking for it
# will list backed up files at the end so you know it did the job


# Define USB UUID and mount point
# get UUID with command: lsblk -f

#!/bin/bash

# Define variables
USB_MOUNT_POINT="/mnt/pve/USB_4GB_PM_BUP"
UUID="4fa17259-5777-4c7e-86e9-a23878802a4d"  # The UUID of your USB
BACKUP_SRC="/etc"  # Source directory to backup
BACKUP_DIR_BASE="$USB_MOUNT_POINT"  # Base backup directory on USB

# Function to create the mount point if it doesn't exist
ensure_mount_point() {
    if [[ ! -d "$USB_MOUNT_POINT" ]]; then
        echo "Mount point $USB_MOUNT_POINT does not exist. Creating it..."
        mkdir -p "$USB_MOUNT_POINT"
        if [[ $? -eq 0 ]]; then
            echo "Mount point created successfully."
        else
            echo "Failed to create mount point. Please check permissions."
            exit 1
        fi
    else
        echo "Mount point $USB_MOUNT_POINT already exists."
    fi
}

# Function to force unmount if the drive is mounted
unmount_drive() {
    echo "Checking if the USB drive is already mounted..."
    
    # Check if the USB is already mounted
    if mount | grep "$USB_MOUNT_POINT" > /dev/null; then
        echo "USB drive already mounted at $USB_MOUNT_POINT."
        
        # Try unmounting gracefully first
        echo "Attempting to unmount the USB drive..."
        umount "$USB_MOUNT_POINT"
        
        # If unmount fails, try to force unmount
        if mount | grep "$USB_MOUNT_POINT" > /dev/null; then
            echo "Graceful unmount failed. Attempting to force unmount in 5 seconds..."
            sleep 5
            umount -l "$USB_MOUNT_POINT"
            
            # Retry graceful unmount after forced unmount
            if mount | grep "$USB_MOUNT_POINT" > /dev/null; then
                echo "Force unmount also failed. Please check the drive."
                exit 1
            fi
        fi
        echo "USB drive unmounted successfully."
    else
        echo "USB drive is not mounted, proceeding..."
    fi
}

# Function to create the backup directory on the USB drive
create_backup_directory() {
    TIMESTAMP=$(date +%Y%m%d%H%M)
    HOSTNAME=$(hostname)
    BACKUP_DIR="$BACKUP_DIR_BASE/$TIMESTAMP-$HOSTNAME"

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

# Function to mount the USB drive and add to /etc/fstab
mount_usb() {
    echo "Attempting to mount the USB drive..."
    
    # Check if the drive is already mounted, if not, mount it
    if ! mount | grep "$USB_MOUNT_POINT" > /dev/null; then
        echo "Mounting USB drive..."
        mount UUID=$UUID "$USB_MOUNT_POINT"
        
        # Check if the mount was successful
        if mount | grep "$USB_MOUNT_POINT" > /dev/null; then
            echo "USB drive mounted successfully at $USB_MOUNT_POINT."
        else
            echo "Failed to mount the USB drive."
            exit 1
        fi
    else
        echo "USB drive is already mounted."
    fi
    
    # Add the mount entry to /etc/fstab for Proxmox to recognize it
    echo "Ensuring USB mount entry in /etc/fstab..."
    grep -q "$USB_MOUNT_POINT" /etc/fstab || echo "UUID=$UUID $USB_MOUNT_POINT ext4 defaults,nofail 0 0" >> /etc/fstab
    
    # Ensure fstab changes are applied
    mount -a
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

# 1. Ensure the mount point exists
ensure_mount_point

# 2. Force unmount the USB drive (if already mounted)
unmount_drive

# 3. Mount the USB drive and add it to /etc/fstab
mount_usb

# 4. Create the backup directory on the USB drive
create_backup_directory

# 5. Perform the backup
perform_backup

# 6. List backup stats (size, file count)
list_backup_stats

echo "Backup script completed. USB drive remains mounted."
