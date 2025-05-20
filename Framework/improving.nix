{ config , pkgs, ... } :

{
	users.users.djs = {
		packages = with pkgs; [
			ungoogled-chromium
			teams-for-linux
			microsoft-edge
			windsurf
		];
	};
}

