{ inputs, outputs, lib, config, pkgs, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
	home ={
		username = "rdp";
		homeDirectory = "/home/rdp";
		# You should not change this value, even if you update Home Manager. If you do
		# want to update the value, then make sure to first check the Home Manager
		# release notes.
		stateVersion = "24.05";
		
	};

	# Home Manager is pretty good at managing dotfiles. The primary way to manage
	# plain files is through 'home.file'.
	home.file = {
	};

	home.sessionVariables = {
		EDITOR = "nano";
	};

	# if not nixOS chsh to /usr/bin/zsh else change users.defaultShell
		nixpkgs.config.allowUnfree=true;
		fonts.fontconfig.enable = true;
		# BEGIN SHELL CONFIGS
		# BEGIN BASH
		home.packages = with pkgs; [
			libreoffice
			htop
			git
			gimp
			vlc
			zsh
			xdg-utils
			brave

			# x2g0
			(pkgs.nerdfonts.override { fonts=["DroidSansMono" ]; }) # for vscode
			];



  imports = [
		./configs/git.nix
		./configs/xdg.nix
		./configs/vscodium.nix
		./configs/shells.nix
		./configs/plasma.nix
		../system/programs/msmtp.nix
  ];


}
