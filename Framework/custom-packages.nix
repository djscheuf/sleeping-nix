{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      # Custom Windsurf package from local repo
      windsurf-custom = super.callPackage /home/djs/Documents/nixpkg-windsurf/package.nix {
        vscode-generic = import (super.path + "/pkgs/applications/editors/vscode/generic.nix");
        curl = super.curl;
        openssl = super.openssl;
        webkitgtk_4_1 = super.webkitgtk_4_1;
        libsoup_3 = super.libsoup_3;
      };
    })
  ];
}
