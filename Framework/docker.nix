{ config , pkgs, ... } :

{
	users.users.djs = {
		packages = with pkgs; [
			docker
		];
	};

 	virtualisation.docker.enable = true;
}

