{ config , pkgs, ... } :

{
	users.users.djs = {
		packages = with pkgs; [
			# Citrix EULA forbids fetching the tarball automatically; drop the
			# linuxx64-<version>.tar.gz matching unstable's expected version into
			# Framework/citrix/ and it is copied into the store at eval time.
			(unstable.citrix_workspace.overrideAttrs (old: rec {
				version = "26.08.0.225";
				src = ./citrix/linuxx64-26.08.0.225.tar.gz;
			}))
		];
	};

}

