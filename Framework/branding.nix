{ config , pkgs, ... } :

{
	users.users.djs = {
		packages = with pkgs; [
			gimp-with-plugins
		];
	};
	fonts.packages = with pkgs; [
		garamond-libre
		arkpandora_ttf #Metrically Identidal to Arial and TNR Fonts
		roboto
		libre-baskerville
	];

	fonts.fontDir.enable = true; # should give all programs access to fonts thru a shared fonts folder
}

