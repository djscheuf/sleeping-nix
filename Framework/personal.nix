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
            sound-juicer
            makemkv
            handbrake
            yt-dlp
		];
	};

    # Ensures Makemkv can see Optical Disc Drives
    # https://discourse.nixos.org/t/makemkv-cant-find-my-usb-blu-ray-drive/23714/3
    boot.kernelModules = ["sg"];

}

