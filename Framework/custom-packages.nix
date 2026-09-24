{ config, pkgs, ... }:

let
  # Pinned nixpkgs-unstable, used to pull in packages that aren't in the
  # nixos-25.11 channel yet (e.g. `handy`, which currently only exists on
  # nixos-unstable). Update by bumping the commit to a newer nixos-unstable
  # commit and recomputing the hash with:
  #   nix-prefetch-url --unpack https://github.com/NixOS/nixpkgs/archive/<commit>.tar.gz
  unstableSrc = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/6774f7bc253789b113a4f39285dc0fa100abeacc.tar.gz";
    sha256 = "1jmanihn33h564jk6fzpcjrrhyhchb11mqqkh6bdplnb5kw8i21i";
  };
in
{
  nixpkgs.overlays = [
    (self: super: {
      # Pinned nixpkgs-unstable package set, exposed as `pkgs.unstable.*`
      unstable = import unstableSrc {
        config = config.nixpkgs.config;
      };

      # Custom Windsurf package from local repo
      windsurf-custom = super.callPackage /home/djs/Documents/nixpkg-windsurf/package.nix {
        vscode-generic = import (super.path + "/pkgs/applications/editors/vscode/generic.nix");
        curl = super.curl;
        openssl = super.openssl;
        webkitgtk_4_1 = super.webkitgtk_4_1;
        libsoup_3 = super.libsoup_3;
      };
      
      # Custom Devin CLI package from local repo
      devin-cli-custom = super.callPackage /home/djs/Documents/devin-cli-nixpkg/devin-cli/default.nix {
        pkgs = super;
      };
      
      # Custom Teams Alt package for secondary account
      teams-for-linux-alt = super.callPackage /home/djs/Documents/teams-alt-nixpkg/package.nix {
        teams-for-linux = super.teams-for-linux;
      };
    })
  ];
}
