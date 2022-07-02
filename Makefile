skhd-init:
	launchctl bootstrap  gui/501  ~/Library/LaunchDaemons/org.nixos.skhd.plist 

skhd-restart:
	launchctl kickstart -k gui/501/org.nixos.skhd