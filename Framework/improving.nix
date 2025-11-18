{ config , pkgs, ... } :

{
	users.users.djs = {
		packages = with pkgs; [
			ungoogled-chromium
			teams-for-linux
			# microsoft-edge # removed due to lack of maint in NixPkgs
			windsurf-custom
			direnv
			devcontainer
			zoom-us
			tailscale
			remmina
		];
	};

	services.tailscale.enable = true;
	# log in with `tailscale login`, follow the link; supports multiple accounts (we think)
	# check status with `tailscale status`
}

