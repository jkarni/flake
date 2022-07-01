skhd-init:
	launchctl bootstrap  gui/501  ~/Library/LaunchDaemons/org.nixos.skhd.plist 
	launchctl enable gui/501/org.nixos.skhd

skhd-restart:
	launchctl kickstart -k gui/501/org.nixos.skhd