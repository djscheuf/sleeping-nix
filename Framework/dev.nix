{ config , pkgs, ... } :

{
	users.users.djs = {
		packages = with pkgs; [
			git
			vscode-fhs
			fira-code-symbols
			nodejs_20
			lmstudio
			azuredatastudio
			bitwarden-cli
		];
	};
}

