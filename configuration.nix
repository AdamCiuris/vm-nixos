#Edit this configuration file to define what should be installed on
# your system.	Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ plasma-manager, config, nixpkgs, pkgs, ... }:
{
	imports =
		[ # Include the results of the hardware scan.
		<nixpkgs/nixos/modules/virtualisation/google-compute-image.nix>
		];

	# filesystems."/" = {
	# 	device = "/dev/sdb";
	# 	fsType = "ext4";
	# };
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
		logRefusedConnections =true;# logs are in dmesg or journalctl -k
		allowedTCPPorts = [ 22 ];
		# interface specific rules
		# networking.firewall.interfaces."eth0".allowedTCPPorts = [ 80 443 ];
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
			passwordAuthentication = true; # if false require pub key

		};

		fail2ban = { # puts bad ssh attempts in jail 
			enable = true;
			bantime = "300m";
			maxretry= 3;
			banaction = "iptables-allports"; # uses iptables to block ip from every port
			# pretty sure these are all DEFAULT
			jails = { 
				ssh = ''
					enable = true
					filter = sshd
					logpath = /var/log/ssh_auth.log
					maxretry = 3
					findtime = 300m
					bantime = 300m
					banaction = iptables-allports
				'';

			};
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
				defaultWindowManager = "startplasma-x11";
				confDir = /etc/xrdp;
				port = 8181;
				openFirewall=false; # https://c-nergy.be/blog/?p=14965/
			};
		pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
		};
	};
	
	sound.enable = true;
	security.rtkit.enable = true;

	# https://nixos.wiki/wiki/Bluetooth
	hardware.bluetooth.enable = false;

	users ={
		mutableUsers = true; # let's you change the passwords after btw
		users= {
			root = {
				# hash a password with mkpasswd -m sha-512
				initialHashedPassword="$6$YRrVyps98/izQa0O$3fR8f/uNEb8B7lXYMu1lE85PZVKp3/Lc8Gc8J2mEwKr9SlUBYGKcbFcWE/SOWnvfRordhUDwv6SXilQ38o.ww1";
				shell=pkgs.zsh;
				useDefaultShell = true; # should be zsh
				isSystemUser = true;
			}; 
			nyx = {
				isNormalUser = true;
				description = "nyx";
				initialHashedPassword = "$6$7ACOHeLr65U7C1Pb$oNIgMK/8iWH9AbLmhyqlJ.HyUQQst5H7jyV5IGsux4j9X7N/Fwm9Mo8u1ijOmqlGjN5ewEhPt.BsWBt518.Rw1";
				shell=pkgs.zsh;
				useDefaultShell = true; # should be zsh
				extraGroups = [ "wheel" ];
				packages = with pkgs; [
					zsh
				];
				openssh= {
					authorizedKeys.keys = [ # dXAgdG8gbm8gZ29vZA==
								"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCr3aeLoj93/PgmLpNIKLEA3flVLaRbZVnyoJzK2OF+I/jkU2ZIpVLels7q1zrsaWOevZ9J9QVg/TqbXsh3pd+qg++lHU9SV6P3oJHCwj7KNGN72rohFdOjjjpVqriAW03aDbB0XmMDwc6WfWNeIspRPn8PN0rL9EUFTX8hjmKp7ljs6mEwN4yOPVgtEit+5w2xWKQVe4cA57I2s0IAeovSr01a5JpFGgMVBnBjK0ljr/ZgypU/dUcxpVS6my4eekha8mGZgjwdofQSukiYybKkk4pMSjXORZcT1oZMUHrlgd/Ea8foiPSVAFvw8F6d2RqiWhNnxgcRsHm3ZQ4dyLOwXofqd5FS/2bE1sAn/R/OMyaM/S7YTrmX1S1a1M5PYqakcVbKcttXJHltFlNTaiklcncgnejsYC1vws+F5G4CMuVAn8UR3oEBcUXbgodt1VrnTf4hG0PlbB2ux6X3dFrUnLQBtdSk2blHVfzP0XNhL6I7NcQF2y3FcyVSEc06uCM= amnesia@amnesia"
						];
				};
			};
				adamciuris = {
				isNormalUser = true;
				description = "gcloud work pls";
				initialHashedPassword = "$6$ImaOHGRpSLuFOUpF$cPhDbahxmy35ohvYwZIK5BX4o5gvVCeeiOCAaYDCvPPf9geikS.Agw2lCxqoZjHsHS6W/6ksxaplRh2evS1x8.";
				shell=pkgs.zsh;
				useDefaultShell = true; # should be zsh
				extraGroups = [ "wheel" ];
				packages = with pkgs; [
					zsh
				];
				openssh= {
					authorizedKeys.keys = [ 
								# Added by Google
								''ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBED6yywm4LUKe9lzphOW3SIGxWE/Bx6KGnb95baznvAAr8fu/DwIjU9kv0OZn4RcUTLuhoEFQlYnv8V5h3pi9EI= google-ssh {"userName":"adamciuris@gmail.com","expireOn":"2024-05-01T22:54:34+0000"}''
								# Added by Google
								''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAGtQsU1mQpjd9sHjvusYmGX/uEVItGqH6uFGjFrtzZs3R6W8F2MAvpEZriexxgvxcfMaF9j2rf9o6Y3dhVZmKf9oOXiDmZQKYRpaZ2mLd0HIRfRM0pwKnzeRtxUs5+9c63fYz5tCL1AogHXjDcp5sx18NPf5E316vBfNoVZxPWGt+Hc+LN1yNZe6J2mLC3tUo+nSjn/QKumh2370A8A1B+ZbvGitAfIIqHbogWGq3DCs3bkQ9WxPO4fTH/IXbBRkUGvkvRS1siHZaAH+rS2TX4n+Ym5O5A52jtRP9SLKGuu7BnVCE1DZW5DbGv4csWWfiuG4D/eO0uWhVZe1j5ICEGU= google-ssh {"userName":"adamciuris@gmail.com","expireOn":"2024-05-01T22:54:48+0000"}''
								# Added by Google
								''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCbNM48kr/B8WEYT9/lwDE7d8/5wQ31cJI0ELED/7lzz8qpMpZtceIAuyD0fiGjkC8Gt0qnJhM3f7KFMK5gcihz0Nal61UhVh01ny6VohMPuHSRI2fxzL1Y+ZF0S/8uDa57nzwRB8sHcy+ZRFtD7kDky1qKJ0BCn6CHBa5n+biWYf25OKxfFlG4uGbDdvbVhLH6atgq2y0sAL8DCXQmN5HmyywyLyEFcYhNqDj6dlWtiie4PRM+zCDX0C3tzCOt24b2MQ7jXG7xzE/WQNyAV+XELqTkYOdEW4t3yLRNV8egNS+JDUxSky/MGs+S6eQf8p/vbPrsY1/fBSM4CTB/nMLG/642kSBOhKb4y/7TayIzQzLA+Ut8C4OdKZm0UodSb7XS/qHkHgLIYXuFRW39vZFh/WsVZ/UPr1098+GqBgzDSkG+jSV2M1/iTVb/VypiwI1FjuKVmKXazeo97Ji1nabLA5pRnqlpWm8YW0q3he0v6IUzQ7Vk2urERMZ3KbFS+f8= adamciuris@cs-741664149018-default''
								# tails
								"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCr3aeLoj93/PgmLpNIKLEA3flVLaRbZVnyoJzK2OF+I/jkU2ZIpVLels7q1zrsaWOevZ9J9QVg/TqbXsh3pd+qg++lHU9SV6P3oJHCwj7KNGN72rohFdOjjjpVqriAW03aDbB0XmMDwc6WfWNeIspRPn8PN0rL9EUFTX8hjmKp7ljs6mEwN4yOPVgtEit+5w2xWKQVe4cA57I2s0IAeovSr01a5JpFGgMVBnBjK0ljr/ZgypU/dUcxpVS6my4eekha8mGZgjwdofQSukiYybKkk4pMSjXORZcT1oZMUHrlgd/Ea8foiPSVAFvw8F6d2RqiWhNnxgcRsHm3ZQ4dyLOwXofqd5FS/2bE1sAn/R/OMyaM/S7YTrmX1S1a1M5PYqakcVbKcttXJHltFlNTaiklcncgnejsYC1vws+F5G4CMuVAn8UR3oEBcUXbgodt1VrnTf4hG0PlbB2ux6X3dFrUnLQBtdSk2blHVfzP0XNhL6I7NcQF2y3FcyVSEc06uCM= amnesia@amnesia"

						];
				};
			};
			rdp = {
				isNormalUser = true;
				description = "rdp";
				initialHashedPassword = "$6$/uc.82fRtaRDvGGn$n7jEQHRys.AnSha6WJQpu68JkN7JV7ODrQoMT/IX8uaZjf3oa8izOA8MFQl2jGouBxBUpbJpMqPWfM9j6YBHi/";
				shell=pkgs.zsh;
				useDefaultShell = true; # should be zsh
				extraGroups = [ "wheel" ];
				packages = with pkgs; [
					zsh
				];
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
