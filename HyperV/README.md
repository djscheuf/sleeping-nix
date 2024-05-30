# Hyper V Configuration
The `configuration.nix` in this directory was exported from a working NixOS installation running GNOME desktop on 20240530. 

I did scour the internet, mostly ineffectually until happening on a Reddit thread, to be linked later, which pointed out the key change needed to gain desktop function in HyperV.

You need specific video drivers! See Lines 50-51, and 67-69 for the specific changes made. 

I believe the key changes were:
```
services.xserver = {
    # ...
    modules = [ pkgs.xorg.xf86videofbdev ];
    videoDrivers = [ "hyperv_fb"]; # HyperV needed this driver at time of Commit!
  };
```