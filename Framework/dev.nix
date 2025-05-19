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
			docker
			code-cursor
			# windsurf
		];
	};

	# virtualisation.containers.enable = true;
 	virtualisation.docker.enable = true;
	#virtualisation.podman = {
	#	enable = true;
	#	dockerCompat = true;
	#	defaultNetwork.settings.dns_enabled = true;
	#};
	# users.users.djs.extraGroups = [ ];

	# services.cockpit = {
	#	enable = true;
	#	port = 9090;
		# openFirewall = true; # Please see the comments section
	#	settings = {
	#		WebService = {
	#		  AllowUnencrypted = true;
	#	    };
  	#   };
    #};
}

