# Custom Packages

This document explains how custom packages are integrated into this NixOS configuration.

## Windsurf Custom Package

We use a custom Windsurf package from `/home/djs/0_repo/nixpkg-windsurf` to get the latest version without waiting for nixpkgs updates.

### How it works

1. **`custom-packages.nix`** - Defines a nixpkgs overlay that adds `windsurf-custom` to the package set
2. **`improving.nix`** - Uses `windsurf-custom` instead of the standard nixpkgs version
3. **`configuration.nix`** - Imports `custom-packages.nix` to enable the overlay

### Updating Windsurf

To update to a newer version of Windsurf:

1. Navigate to the package repo:
   ```bash
   cd /home/djs/0_repo/nixpkg-windsurf
   ```

2. Update the `info.json` file with new version information:
   - Update `version` field
   - Update `url` to point to the new release
   - Update `sha256` hash (you can use `nix-prefetch-url <url>` to get the hash)

3. Rebuild your NixOS configuration:
   ```bash
   sudo nixos-rebuild switch
   ```

### Adding more custom packages

To add additional custom packages, edit `custom-packages.nix` and add them to the overlay:

```nix
nixpkgs.overlays = [
  (self: super: {
    windsurf-custom = super.callPackage /home/djs/0_repo/nixpkg-windsurf/package.nix { };
    
    # Add more custom packages here:
    # my-package = super.callPackage /path/to/package.nix { };
  })
];
```

### Troubleshooting

If the build fails:
- Check that `/home/djs/0_repo/nixpkg-windsurf/package.nix` exists and is valid
- Verify the `info.json` has correct URLs and hashes for your platform
- Check build logs: `sudo nixos-rebuild switch --show-trace`
