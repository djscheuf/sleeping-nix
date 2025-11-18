{ config , pkgs, ... } :

{
	users.users.djs = {
		packages = with pkgs; [
			git
			vscode-fhs
			fira-code-symbols
			lmstudio
			azuredatastudio
			bitwarden-cli
			nodejs_20
			pnpm
			dotnetCorePackages.sdk_8_0-bin
			insomnia
		];
	};
}

