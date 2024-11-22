#!/bin/zsh
# ==============================================================================
# Title: install.sh
# Description: Automates the setup and configuration of macOS, including
#              installation of essential applications and system preferences.
# ==============================================================================

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
echo "${RED}Configuring default system settings?"
echo "${NC}"

# Finder settings
defaults write com.apple.finder ShowRecentTags 0
defaults write com.apple.finder FXDefaultSearchScope SCcf
defaults write com.apple.finder DisableAllAnimations 1
defaults write com.apple.finder AppleShowAllFiles 1
defaults write com.apple.finder ShowPathbar 1
defaults write com.apple.finder ShowStatusBar 1
defaults write com.apple.finder NewWindowTarget PfHm
defaults write com.apple.Finder FXPreferredViewStyle Nlsv
defaults write com.apple.finder _FXSortFoldersFirst 1
defaults write com.apple.finder FXEnableExtensionChangeWarning 0
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop 0
defaults write com.apple.finder ShowRemovableMediaOnDesktop 0
defaults write com.apple.finder AppleShowAllExtensions 1

# Desktop and dock settings
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop 0
defaults write com.apple.desktopservices DSDontWriteNetworkStores 1
defaults write com.apple.desktopservices DSDontWriteUSBStores 1
defaults write com.apple.dock "orientation" -string left
defaults write com.apple.dock "show-recents" -bool false
defaults write com.apple.dock "mineffect" -string scale

# Other settings
defaults -currentHost write com.apple.ImageCapture disableHotPlug 1
defaults write com.apple.screencapture "disable-shadow" -bool true
defaults write com.apple.screencapture "location" -string "~/Data/Screenshots"
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true
defaults write com.apple.TimeMachine "DoNotOfferNewDisksForBackup" -bool true
chflags nohidden ~/Library

# Safari settings
defaults write com.apple.Safari ShowFullURLInSmartSearchField 1
defaults write com.apple.Safari AlwaysRestoreSessionAtLaunch 1
defaults write com.apple.Safari ExcludePrivateWindowWhenRestoringSessionAtLaunch 1
defaults write com.apple.Safari ShowBackgroundImageInFavorites 0
defaults write com.apple.Safari ShowFavorites 0
defaults write com.apple.Safari ShowFrequentlyVisitedSites 0
defaults write com.apple.Safari ShowHighlightsInFavorites 0
defaults write com.apple.Safari ShowPrivacyReportInFavorites 0
defaults write com.apple.Safari ShowReadingListInFavorites 0
defaults write com.apple.Safari HideStartPageSiriSuggestionsEmptyItemView 0
defaults write com.apple.Safari ShowSiriSuggestionsPreference 0
defaults write com.apple.Safari NSNavLastRootDirectory "~/Downloads"
defaults write com.apple.Safari DownloadsClearingPolicy 2
defaults write com.apple.Safari AutoOpenSafeDownloads 0
defaults write com.apple.Safari OpenNewTabsInFront 1
defaults write com.apple.Safari IncludeDevelopMenu 1


# Dock settings
echo
echo "${RED}Applying dock settings.."
echo "${NC}"

echo "${GREEN}Installing dockutil.."
echo "${NC}"
brew install dockutil

echo "${GREEN}Removing dock items.."
echo "${NC}"
dockutil --remove "Maps"
dockutil --remove "FaceTime"
dockutil --remove "Contacts"
dockutil --remove "Freeform"
dockutil --remove "TV"
dockutil --remove "News"
dockutil --remove "Mail"

echo "${GREEN}Adding dock items.."
echo "${NC}"
dockutil --add "/Applications/WezTerm.app"
dockutil --add "/Applications/Zed.app"
dockutil --add "/Applications/Windows App.app"
dockutil --add "/Applications/Signal.app"
dockutil --add "/Applications/Firefox.app"
dockutil --add "/Applications/Brave Browser.app"
dockutil --add "/Applications/Google Chrome.app"
dockutil --add "/Applications/Proton Mail.app"
dockutil --add "/Applications/Proton Pass.app"


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
