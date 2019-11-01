#!/usr/bin/env bash

read -rp "This command will do an instant reboot when finished. Are you sure to continue? (y/n)" answer
echo ""

if [ "$answer" == "n" ]; then
  echo "No changes applied, operation cancelled"
  exit 0
fi

sudo -v

echo "Closing System Preferences window opened to prevent changes..."
osascript -e 'tell application "System Preferences" to quit'
echo ""

#######################################
# System preferences > General
#######################################

# Show scroll bars when scrolling
defaults write -g AppleShowScrollBars -string WhenScrolling

# Disable font smooth
defaults -currentHost write -globalDomain AppleFontSmoothing -int 0

# Disable font smooth (Mojave)
defaults write -g CGFontRenderingFontSmoothingDisabled -bool false

#######################################
# System preferences > Mouse
#######################################

# Change the value of mouse acceleration
defaults write -g com.apple.mouse.scaling -1

# Disable scroll direction natural
defaults write -g com.apple.swipescrolldirection -bool false

#######################################
# System Preferences > Keyboard
#######################################

# Keyboard repeat fast
defaults write -g KeyRepeat -int 2

# Delay until repeat short
defaults write -g InitialKeyRepeat -int 15

# Disable spell correction
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

#######################################
# System Preferences > Energy saver
#######################################

# Disable wake for ethernet network access
sudo systemsetup -setwakeonnetworkaccess off

# Computer sleeps never
sudo systemsetup -setcomputersleep Never

# Display sleeps in 20 minutes
sudo systemsetup -setdisplaysleep 20

#######################################
# System Preferences > Users & Groups
#######################################

# Disable guest user
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool NO
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool NO
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool NO

#######################################
# System Preferences > Dock
#######################################

# Minimize apps on App icon
defaults write com.apple.dock minimize-to-application -int 1

# Turn hiding off
defaults write com.apple.Dock autohide -int 1

# Disable show recent applications in Dock
defaults write com.apple.Dock show-recents -int 0

#######################################
# Menu bar
#######################################

# Clean all the menu bar
defaults write com.apple.systemuiserver menuExtras -array ""

# Show Date, Volume and Bluetooth
defaults write com.apple.systemuiserver menuExtras -array "/System/Library/CoreServices/Menu Extras/Clock.menu" "/System/Library/CoreServices/Menu Extras/Volume.menu" "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"

# Restart menu bar service
killall SystemUIServer

#######################################
# System Preferences > Date & Time
#######################################

# Change date format on menu bar
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM  HH:mm"

#######################################
# Finder
#######################################

# Always open finder as list view
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# New window opens home folder
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Search on the current folder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

#######################################
# Safari
#######################################

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

#######################################
# Text edit
#######################################

# TextEdit plain text mode as default
defaults write com.apple.TextEdit RichText -int 0

#######################################
# macOS UI
#######################################

# Accelerated playback when adjusting the window size
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Make all animations faster that are used by Mission Control
defaults write com.apple.dock expose-animation-duration -float 0.1

#######################################
# Dashboard
#######################################

# Disable dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

#######################################
# Mojave sleep fixs
#######################################

# Disable stand by (long sleep)
sudo pmset -a standby 0

#######################################
# Network
#######################################

# Set Cloudflare DNS
networksetup -setdnsservers "Ethernet" 1.1.1.1 1.0.0.1
# networksetup -setdnsservers "802.11n NIC" 1.1.1.1 1.0.0.1

#######################################
# SSD/M2
#######################################

# Enable TRIM
if [ ! -e "${COMMAND_PATH}/trim.lock" ]; then
  touch "${COMMAND_PATH}/trim.lock"
  sudo trimforce enable
fi


# reboot
sudo reboot now