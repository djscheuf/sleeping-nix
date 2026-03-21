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
		nerd-fonts.open-dyslexic # Added for Dyslexia support
	];

	fonts.fontDir.enable = true; # should give all programs access to fonts thru a shared fonts folder
}

