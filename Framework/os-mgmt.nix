{ configs, lib, pkgs, ... } : 

{
	#setting up automated cron nix GC
	nix.gc = {
		automatic = true;
		dates = "weekly"; # runs weekly
		options = "--delete-older-than 7d"; # anything older than 1 weeks.
		persistent = true;
		# should never delete current generation.
	};	

	# Limit boot menu entries (choose based on your bootloader)
    boot.loader.systemd-boot.configurationLimit = 7;
  	# boot.loader.grub.configurationLimit = 7;

  	# Automatic store optimization (deduplication)
  	nix.optimise.automatic = true;
  
	# Space-based safety net
	nix.extraOptions = ''
		min-free = ${toString (3 * 1024 * 1024 * 1024)}      # 3GB threshold
		max-free = ${toString (10 * 1024 * 1024 * 1024)}  # Free up to 10GB
	'';

	system.autoUpgrade.enable = true;
	system.autoUpgrade.channel = "https://channels.nixos.org/nixos-25.11";
}
