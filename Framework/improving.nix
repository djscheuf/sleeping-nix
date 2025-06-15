{ config , pkgs, ... } :

{
	users.users.djs = {
		packages = with pkgs; [
			ungoogled-chromium
			teams-for-linux
			# microsoft-edge # removed due to lack of maint in NixPkgs
			windsurf
			direnv
			devcontainer
			zoom-us
		];
	};
}

