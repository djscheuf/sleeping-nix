{ config , pkgs,  ... } :

{

	# Enable dconf (Sys Mgmt Tool)
	programs.dconf.enable = true;

	# Add user to libvertd group
	users.users.djs.extraGroups = [ "libvirtd" ];

	# Install necessary pkgs 
	environment.systemPackages = with pkgs; [
		virt-manager
		virt-viewer
		spice spice-gtk
		spice-protocol
		win-virtio
		win-spice
		gnome.adwaita-icon-theme # needed some Virt-manager app won't crash when trying to load iconsS
		OVMFFull # appears to have issue in that part of the binary isn't included.
		# pursuing solution from https://bbs.archlinux.org/viewtopic.php?id=301554
		qemu_kvm
		binutils
	];

	# Manager virtualization services
	virtualisation = {
		libvirtd = {
			enable = true;
			qemu = {
				package = pkgs.qemu_kvm;
				runAsRoot = true;
				swtpm.enable = true;
				ovmf.enable = true;

				# Issue occurs as this package output is not null or package. Perhaps issue with OVMFFull itself?
				ovmf.packages = [ pkgs.OVMFFull.fd ];
			};
		};
		spiceUSBRedirection.enable = true;
	};
	services.spice-vdagentd.enable = true;

	systemd.tmpfiles.rules =
		let
		   firmware =
		      pkgs.runCommandLocal "qemu-firmware" { } ''
		        mkdir $out
		        cp ${pkgs.qemu}/share/qemu/firmware/*.json $out
		        substituteInPlace $out/*.json --replace ${pkgs.qemu} /run/current-system/sw
		      '';
		in
		[ "L+ /var/lib/qemu/firmware - - - - ${firmware}" ];
}

