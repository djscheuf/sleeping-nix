# Framework
- Backup of Working Config from Framework Laptop. 
- Plan is to eventually move to flakes for compositional approach. 

## Setup
- Full Config
    - gc - Garbage Collection setup
    - dev - Common tools for Development (may move lang to flakes)
    - vm - virtual machine setup. May need some cleanup
    - record - tools for Podcast recording.
    - debug - setup OS to take crashDump, and other settings as needed
    - printing - Printer setup, not fully tested
    - certs - certbot setup for renewing site certs :-P
    - personal - collection of tools used personally, rather than specifically for a function like dev, record, or print
- Used Symlink to Configuration.nix in `/etc/nixos/` with full-path link to the hardwar-config to allow better control by user over docs. 

## Win11 VM
- XML structure capturing key changes made for Libvirt/QEMU VM
- Specifically needed to pull CentOS OVMF.fd files to make secureboot work

## Upgrading NixOS Version
- https://ostechnix.com/upgrade-nixos/
Check your current version:
```
cat /etc/os-release
```

check your current channel:
```
sudo nix-channel --list | grep nixos
```

Update your Channel:
```
sudo nix-channel --add https://channels.nixos.org/nixos-{new-version} nixos
```

Or update to Unstable:
```
sudo nix-channel --add https://channels.nixos.org/nixos-unstable nixos
```

Then pass the `--upgrade` flag to the rebuild command.