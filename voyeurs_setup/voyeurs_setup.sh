#!/bin/sh

# README:
#
# This script assumes:
# 1. You added the voyeurs account
# 2. That you already copied over the
#    sshd_config and the authorized_keys files into
#    the current directory before execution.
#
USER_SSH=voyeurs

sudo mkdir /home/$USER_SSH/.ssh
sudo mkdir /home/$USER_SSH/.ssh
# In case we forgot the -m swich on useradd to make home directory:
sudo mkdir /home/$USER_SSH
sudo chown $USER_SSH:$USER_SSH /home/$USER_SSH
sudo mkdir /home/$USER_SSH/.ssh
# authorized_keys must be in the user's home directory with these permissions:
sudo cp /home/$USER_SSH/.ssh/authorized_keys /home/$USER_SSH/.ssh/authorized_keys.bak
sudo mv authorized_keys /home/$USER_SSH/.ssh/authorized_keys
sudo chmod 0644 /home/$USER_SSH/.ssh/authorized_keys
sudo chown root:root /home/$USER_SSH/.ssh/authorized_keys

sudo mv /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sudo mv sshd_config /etc/ssh/sshd_config
# Ensure appropriate sshd_config permissions:
sudo chown root:root /etc/ssh/sshd_config
sudo chmod 0644 /etc/ssh/sshd_config

# Allow passwordless sudo:
sudo mkdir /etc/sudoers.d
echo $USER_SSH" ALL=(ALL:ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/$USER_SSH

# Restart SSH Deamon
echo "Keyfiles/configs copied, restarting SSH..."
#Try service and systemctl, continue on errors for compatibility issues:
sudo service ssh reload ||: sudo service ssh restart ||:
sudo systemctl restart ssh ||: sudo systemctl reload ssh ||:
