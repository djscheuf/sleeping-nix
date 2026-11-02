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
			dotnet-sdk_10
			jq
			python315
			claude-code
		];
	};
}

