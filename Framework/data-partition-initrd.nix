{ config, pkgs, ... }:

{
  # Encrypted data partition configuration - INITRD VERSION
  # This unlocks and mounts the old root filesystem during boot (in initrd stage)
  # The partition is unlocked with the same passphrase as swap
  
  # Add data partition to LUKS devices unlocked during boot
  boot.initrd.luks.devices."luks-data" = {
    device = "/dev/disk/by-uuid/3d5275cd-afed-439c-99a4-4dac41b7dd69";
    # No keyFile specified - will prompt for passphrase (same as swap)
  };
  
  # Mount the decrypted data partition at /mnt/data
  fileSystems."/mnt/data" = {
    device = "/dev/mapper/luks-data";
    fsType = "ext4";
    options = [ "defaults" ];
    # Note: We mount at /mnt/data to avoid any conflicts with the OS root
    # The old /boot directory in this partition will NOT be used by the system
  };
  
  # Create the mount point
  systemd.tmpfiles.rules = [
    "d /mnt/data 0755 root root -"
  ];
}
