{ config , pkgs, ... } :

{
	users.users.djs = {
		packages = with pkgs; [
			git
			vscode-with-extensions
			fira-code-symbols
			nodejs_20
			lmstudio
			azuredatastudio
		];
	};
}

