{ config , pkgs, ... } :

{
	users.users.djs = {
		packages = with pkgs; [
			obs-studio
			openshot-qt
			audacity
		];
	};
}

