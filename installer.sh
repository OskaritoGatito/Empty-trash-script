#!/bin/bash

# Define file names
SCRIPT_NAME="empty_trash.sh"
SERVICE_NAME="empty_trash.service"
TIMER_NAME="empty_trash.timer"

# Safety check: Ensure the script is NOT run as root/sudo
if [ "$EUID" -eq 0 ]; then
    echo "Error: Do NOT run this script with sudo or as root!"
    echo "Please run it as a common user: ./install.sh"
    exit 1
fi

echo "Starting user-level installation..."

# Create necessary directories in the user's home space if they're not created before
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config/systemd/user"

# Copy the executable script and set execution permissions
echo "Copying script to ~/.local/bin/..."
cp "$SCRIPT_NAME" "$HOME/.local/bin/$SCRIPT_NAME"
chmod +x "$HOME/.local/bin/$SCRIPT_NAME"

# Copy systemd configuration files to the user's systemd directory
echo "⚙Copying systemd user units..."
cp "$SERVICE_NAME" "$HOME/.config/systemd/user/$SERVICE_NAME"
cp "$TIMER_NAME" "$HOME/.config/systemd/user/$TIMER_NAME"

# Reload systemd user manager and enable/start the timer
echo "Activating systemd timer..."
systemctl --user daemon-reload
systemctl --user enable "$TIMER_NAME"
systemctl --user start "$TIMER_NAME"

echo "Installation completed successfully!"
