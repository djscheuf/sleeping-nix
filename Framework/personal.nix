{ config , pkgs, ... } :

{
	users.users.djs = {
		packages = with pkgs; [
			obsidian
            firefox
            bitwarden-desktop
            libreoffice-qt6-fresh	
            mgba
            calibre
            libation
		];
	};
}

