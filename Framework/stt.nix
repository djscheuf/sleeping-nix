{ config, pkgs, ... }:

{
users.users.djs = {
		packages = with pkgs; [
			hns
      xclip # for clipboard integration
		];
	};
}