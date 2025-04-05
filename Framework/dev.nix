{ config , pkgs, ... } :

{
	users.users.djs = {
		packages = with pkgs; [
			ungoogled-chromium
			teams-for-linux
			git
			vscode-with-extensions
			fira-code-symbols
			nodejs_20
			lmstudio
			microsoft-edge
		];
	};
}

