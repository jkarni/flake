darwin-firefox-env-init:
	sudo launchctl bootstrap  system  /Library/LaunchAgents/org.nixos.FirefoxEnv.plist

darwin-firefox-profile-backup:
	restic  backup "/Users/dominic/Library/Application Support/Firefox/default" --exclude="chrome"

darwin-firefox-profile-restore:
	restic restore latest  --target / --path "/Users/dominic/Library/Application Support/Firefox/default" 

linux-firefox-profile-backup:
	restic  backup "/home/dominic/.mozilla/firefox/default" --exclude="chrome"

linux-firefox-profile-restore:
	restic restore latest  --target / --path "/home/dominic/.mozilla/firefox/default" 

launchd:
	launchctl unload ~/Library/LaunchAgents/org.nixos.SKHD.plist
	launchctl load -w ~/Library/LaunchAgents/org.nixos.SKHD.plist
	launchctl unload ~/Library/LaunchAgents/org.nixos.RcloneMount.plist
	launchctl load -w ~/Library/LaunchAgents/org.nixos.RcloneMount.plist
