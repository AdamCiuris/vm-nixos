{ inputs, outputs, lib, config, pkgs, ... }:
let
	shellExtra = ''
		# BEGIN XDG_DATA_DIRS CHECK
		# used to add .desktop files to xdg-mime from nix profile if dne
		# TODO figure out why this gets entered every home-manager switch
		local xdgCheck="$HOME/.nix_profile/share/applications"
		if  [[ ":$XDG_DATA_DIRS:" != *":$xdgCheck:"* ]] ; then
			export XDG_DATA_DIRS="$xdgCheck${":$XDG_DATA_DIRS"}"
		fi	
		# END XDG_DATA_DIRS CHECK
		# BEGIN FUNCTIONS
		desktopFiles() {
			local firstArg="$1"
			echo "searching for $firstArg in $HOME/.nix-profile/share/applications/..."
			ls ~/.nix-profile/share/applications | grep "$firstArg"
			echo "searching for $firstArg in /usr/share/applications/..."
			ls /usr/share/applications | grep "$firstArg"
		}	# END FUNCTIONS


		# BEGIN ALIASES
		alias src="source"; 
		alias resrc="source ~/.zshrc";
		alias ...="../../"; 
		alias nrs="sudo nixos-rebuild switch"; 
		alias "g*"="git add *"; 
		alias gcm="git commit -m";
		alias gp="git push"; # conflicts with global-platform-pro, pari
		alias hms="home-manager switch";
		# END ALIASES
		'';
	ext =  name: publisher: version: sha256: pkgs.vscode-utils.buildVscodeMarketplaceExtension {
	mktplcRef = { inherit name publisher version sha256 ; };
	};

in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
	home ={
		username = "nyx";
		homeDirectory = "/home/nyx";
		# You should not change this value, even if you update Home Manager. If you do
		# want to update the value, then make sure to first check the Home Manager
		# release notes.
		stateVersion = "23.11";
		
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
		programs.bash ={
			enable=true;
			historyControl = ["ignoredups"];
			initExtra = shellExtra;
		}; # END BASH
		# BEGIN ZSH
		programs.zsh = {
			enable = true;
			enableAutosuggestions = true;
			syntaxHighlighting.enable = true;
			oh-my-zsh={
				enable = true;
				# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
				# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo
				# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/systemd
				# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/python
				plugins = [ "git" "sudo" "systemd" "python"];  # a bunch of aliases and a few functions
				theme = "agnoster";  # https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
				};
			initExtra = shellExtra;
			}; # END ZSH
		home.packages = with pkgs; [
			libreoffice
			htop
			git
			# does bootloader.grub.enable = true always have to be commented out for iso gen
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
  ];


}
