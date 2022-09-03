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

# I don't know why launchd will fail to start services and show error code 78 after reboot
# Therefore, I have to manually unload and load services after reboot
launchd:
	launchctl unload ~/Library/LaunchAgents/org.nixos.com.koekeishiya.skhd.plist
	launchctl load -w ~/Library/LaunchAgents/org.nixos.com.koekeishiya.skhd.plist