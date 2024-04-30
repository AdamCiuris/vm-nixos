#Edit this configuration file to define what should be installed on
# your system.	Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ plasma-manager, config, nixpkgs, pkgs, ... }:
{
	imports =
		[ # Include the results of the hardware scan.
		# ./home-manager/home-manager-module.nix
		# ./system/nixos-generators.nix
		./hardware-configuration.nix
		];
	# Bootloader.
	# boot.loader.grub.enable = true;
	# boot.loader.grub.device = "/dev/vda";
	# boot.loader.grub.useOSProber = true;
	boot.loader.grub = {
		enable = true;
		device = "/dev/vda";
		useOSProber = true;
		splashImage = null;
	};
	# Nix settings
	nix.settings.experimental-features = ["nix-command" "flakes"]; # needed to try flakes from tutorial

	networking.hostName = "nixos"; # Define your hostname.
	# networking.wireless.enable = true;	# Enables wireless support via wpa_supplicant.
	# Enable networking
	networking.networkmanager.enable = true;

	# Set your time zone.
	time.timeZone = "America/Chicago";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "en_US.UTF-8";
		LC_IDENTIFICATION = "en_US.UTF-8";
		LC_MEASUREMENT = "en_US.UTF-8";
		LC_MONETARY = "en_US.UTF-8";
		LC_NAME = "en_US.UTF-8";
		LC_NUMERIC = "en_US.UTF-8";
		LC_PAPER = "en_US.UTF-8";
		LC_TELEPHONE = "en_US.UTF-8";
		LC_TIME = "en_US.UTF-8";
	};


	programs = {
		dconf.enable = true;
		zsh.enable = true;
		};


	networking.firewall = {
		enable = true; # this is on by default but still declaring it.
		allowedTCPPorts = [ 22 ];
	};
		# allowedUD
	# reminder you need to run this as root to delete generations from EFI
	# user one is just profiles and home-manager, i think
	nix.gc.automatic = true;
	nix.gc.options = "--delete-older-than 1d";

	services = {
		# Enable the OpenSSH server.
		openssh = {
			enable = true;
			permitRootLogin = "no";
			passwordAuthentication = false; # require pub key

		};

		fail2ban = { # puts bad ssh attempts in jail
			enable = true;
			# jail.local is the default configuration file for fail2ban
			# configFile = pkgs.writeText "jail.local" ''
			# 	[sshd]
			# 	enabled = true
			# 	port = ssh
			# 	filter = sshd
			# 	logpath = /var/log/auth.log
			# 	maxretry = 3
			# 	findtime = 300
			# 	bantime = 3600
			# 	ignoreip = 127.0.0.1
			# 	''; # END jail.local
		};
		# Enable the X11 windowing system.
		xserver = {
			enable = true;
			# Configure keymap in X11
			layout = "us";
			xkbVariant = "";
			# KDE
			desktopManager.plasma5.enable = true;
			displayManager.sddm ={
				enable = true; 
			};
		}; # END X11
		avahi = {
			enable = true;
			# Whether to run the Avahi daemon, which allows Avahi clients to use Avahi’s service discovery facilities and also allows the local machine to advertise its presence and services (through the mDNS responder implemented by avahi-daemon).
			nssmdns = true;
			openFirewall = true;
		};

		spice-vdagentd.enable = true; # enables clipboard sharing between host and guest
		# remote desktop
		xrdp = {
				enable = true;
				port = 8181; 
				openFirewall=true;
			};
		pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
		};
	};
	# Enable CUPS to print documents.

	
	sound.enable = true;
	security.rtkit.enable = true;

	# https://nixos.wiki/wiki/Bluetooth
	hardware.bluetooth.enable = false;

	users ={
		mutableUsers = true; # let's you change the passwords after btw
		users= {
			root = {
				initialHashedPassword="$y$j9T$qhPMNns01CkMEoPsVUSsv/$xmo.lUiUrxdp1eOyrTBonhgGFWhGyNPDr8my3LCz.E0";
				shell=pkgs.zsh;
				useDefaultShell = true; # should be zsh
				isSystemUser = true;
			}; 
			nyx = {
				isNormalUser = true;
				description = "nyx";
				initialHashedPassword = "$y$j9T$Fj7uE/Bbwy/Zk18712MCw1$UjvkW7f2p709pqW8.B.Hor7A4HezmEHAHQ.8.LDTkSD";
				shell=pkgs.zsh;
				useDefaultShell = true; # should be zsh
				extraGroups = [ "wheel" ];
				packages = with pkgs; [
					zsh
				];
				# TODO activate with own key once server up
				# openssh.authorizedKeys.keys = [
						
				# 		];
			};
		};
	};
	security.pam.services.kwallet = {
		name = "kwallet";
		enableKwallet = false;
};
	# needed for vscode in pkgs
	# nixpkgs.config.allowUnfree = true;
	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		vim
		nano # available by default but declare anyways
	];
	system.stateVersion = "23.11"; # Did you read the comment?

}
