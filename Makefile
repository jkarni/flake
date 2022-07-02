# only run once
# skhd-init:
#     cp /opt/homebrew/Cellar/skhd/0.3.5/homebrew.mxcl.skhd.plist  ~/Library/LaunchAgents
#     launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.skhd.plist  # if encounter error, reboot, then bootstrap
# 	launchctl bootstrap gui/501 ~/Library/LaunchAgents/homebrew.mxcl.skhd.plist
# 	launchctl enable gui/501/homebrew.mxcl.skhd

# skhd-restart:
# 	launchctl kickstart -k gui/501/homebrew.mxcl.skhd

firefox-env-init:
	sudo launchctl bootstrap  system  /Library/LaunchAgents/org.nixos.FirefoxEnv.plist