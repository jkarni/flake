# only run once
# skhd-init:
#     cp /opt/homebrew/Cellar/skhd/0.3.5/homebrew.mxcl.skhd.plist  ~/Library/LaunchAgents
#     launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.skhd.plist  # if encounter error, reboot, then bootstrap
# 	launchctl bootstrap gui/501 ~/Library/LaunchAgents/homebrew.mxcl.skhd.plist
# 	launchctl enable gui/501/homebrew.mxcl.skhd

# skhd-restart:
# 	launchctl kickstart -k gui/501/homebrew.mxcl.skhd

darwin-firefox-env-init:
	sudo launchctl bootstrap  system  /Library/LaunchAgents/org.nixos.FirefoxEnv.plist

darwin-firefox-profile-backup:
	restic --verbose backup '/Users/dominic/Library/Application Support/Firefox/default' --exclude="chrome"

darwin-firefox-profile-restore:


linux-firefox-profile-backup:
	restic --verbose backup '/Users/dominic/Library/Application Support/Firefox/default' --exclude="chrome"

linux-firefox-profile-restore: