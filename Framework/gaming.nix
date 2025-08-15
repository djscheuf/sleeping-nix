{ config , pkgs, ... } :

{
	programs.steam.enable = true;

   # users.users.djs = {
	#	packages = with pkgs; [
	#		steam
    #       steam-original
    #      steam-unwrapped
    #      steam-run
	#	];
	# };
}

