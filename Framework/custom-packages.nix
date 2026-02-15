{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      # Custom Windsurf package from local repo
      # vscode-generic is a path to the generic.nix file in nixpkgs
      windsurf-custom = super.callPackage /home/djs/Documents/nixpkg-windsurf/package.nix {
        vscode-generic = super.path + "/pkgs/applications/editors/vscode/generic.nix";
      };
    })
  ];
}
