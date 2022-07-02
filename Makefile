skhd-init:
	launchctl bootstrap  gui/501  ~/Library/LaunchDaemons/org.nixos.skhd.plist 

skhd-restart:
	launchctl kickstart -k gui/501/org.nixos.skhd

firefox-env-init:
	sudo launchctl bootstrap  system  /Library/LaunchAgents/org.nixos.FirefoxEnv.plist