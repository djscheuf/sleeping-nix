{ config , pkgs, ... } :

{
	users.users.djs = {
		packages = with pkgs; [
			certbot
		];
	};
}

