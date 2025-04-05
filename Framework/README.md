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