{ config , pkgs, ... } :

{
	users.users.djs = {
		packages = with pkgs; [
			git
			vscode-fhs
			fira-code-symbols
			lmstudio
			bitwarden-cli
			nodejs_24
			pnpm
			dotnetCorePackages.sdk_8_0-bin
			jq
			python315
		];
	};
}

