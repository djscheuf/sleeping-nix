{ configs, pkgs, ... } : 

{
	#setting up automated cron nix GC
	nix.gc = {
		automatic = true;
		dates = "weekly"; # runs weekly
		options = "--delete-older-than 14d"; # anything older than 2 weeks.
		# should never delete current generation.
	};	
}