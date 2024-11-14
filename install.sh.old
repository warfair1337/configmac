#!/bin/zsh
# ==============================================================================
# Title: install.sh
# Author: Daniel Vier
# Email: daniel.vier@gmail.com
# Description: Automates the setup and configuration of macOS, including
#              installation of essential applications and system preferences.
# Last Updated: March 1, 2024
# ==============================================================================

source ./config

# COLOR
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

#########
# Start #
#########

clear
echo " _           _        _ _       _     "
echo "(_)         | |      | | |     | |    "
echo " _ _ __  ___| |_ __ _| | |  ___| |__  "
echo "| | |_ \/ __| __/ _  | | | / __| |_ \ "
echo "| | | | \__ \ || (_| | | |_\__ \ | | |"
echo "|_|_| |_|___/\__\__,_|_|_(_)___/_| |_|"
echo
echo "${GREEN}Sign in to Apple Account prior to running the script."
echo
echo "${RED}Give Full Disk Access to terminal before continuing the script!"
echo "${RED}This is required for script to write defaults for Safari"
echo "${NC}"
echo Enter root password

# Ask for the administrator password upfront.
sudo -v

# Keep Sudo until script is finished
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# Update macOS
echo
echo "${GREEN}Looking for updates.."
echo "${NC}"
sudo softwareupdate -i -a

# Install Rosetta
echo
echo "${GREEN}Installing Rosetta.."
echo "${NC}"
sudo softwareupdate --install-rosetta --agree-to-license

# Install Homebrew
echo
echo "${GREEN}Installing Homebrew.."
echo "${NC}"
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Append Homebrew initialization to .zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>${HOME}/.zprofile
# Immediately evaluate the Homebrew environment settings for the current session
eval "$(/opt/homebrew/bin/brew shellenv)"

# Check installation and update
echo
echo "${GREEN}Checking installation.."
echo "${NC}"
brew update && brew doctor
export HOMEBREW_NO_INSTALL_CLEANUP=1

# Check for Brewfile in the current directory and use it if present
  echo
  echo "${GREEN}Brewfile found, using it to install packages..."
  echo "${NC}"
  brew bundle
  echo "${GREEN}Installation from Brewfile complete."
  echo "${NC}"

# Cleanup
echo
echo "${GREEN}Cleaning up..."
brew update && brew upgrade && brew cleanup && brew doctor
mkdir -p ~/Library/LaunchAgents

# Settings
echo
echo -n "${RED}Configure default system settings? ${NC}[Y/n]"
echo "${NC}"
read REPLY
if [[ -z $REPLY || $REPLY =~ ^[Yy]$ ]]; then
  echo "${GREEN}Configuring default settings..."
  for setting in "${SETTINGS[@]}"; do
    eval $setting
  done
fi

# Dock settings
echo
echo -n "${RED}Apply Dock settings?? ${NC}[y/N]"
echo "${NC}"
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]; then
  brew install dockutil
  # Handle additions
  for app in "${DOCK_ADD[@]}"; do
    dockutil --add "$app" &>/dev/null
  done
  # Handle removals
  for app in "${DOCK_REMOVE[@]}"; do
    dockutil --remove "$app" &>/dev/null
  done
fi

# Git Login
echo
echo "${GREEN}Set up git.."
echo "${NC}"

echo "${RED}Please enter your git username:${NC}"
read name
echo "${RED}Please enter your git email:${NC}"
read email

git config --global user.name "$name"
git config --global user.email "$email"
git config --global color.ui true

echo
echo "${GREEN}git setup done!"

# ohmyzsh
echo
echo "${GREEN}Installing ohmyzsh!"
echo "${NC}"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo
echo "${GREEN}______ _____ _   _  _____ "
echo "${GREEN}|  _  \  _  | \ | ||  ___|"
echo "${GREEN}| | | | | | |  \| || |__  "
echo "${GREEN}| | | | | | | .   ||  __| "
echo "${GREEN}| |/ /\ \_/ / |\  || |___ "
echo "${GREEN}|___/  \___/\_| \_/\____/ "

echo
echo
printf "${RED}"
read -s -k $'?Press ANY KEY to REBOOT\n'
sudo reboot
exit
