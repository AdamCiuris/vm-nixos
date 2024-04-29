{  config, pkgs, ...}:
let
	shellExtra = ''
		# BEGIN XDG_DATA_DIRS CHECK
		# used to add .desktop files to xdg-mime from nix profile if dne
		# TODO figure out why this gets entered every home-manager switch
		local xdgCheck="$HOME/.nix_profile/share/applications"
		if  [[ ":$XDG_DATA_DIRS:" != *":$xdgCheck:"* ]] ; then
			export XDG_DATA_DIRS="$xdgCheck${":$XDG_DATA_DIRS"}"
		fi	
		# ENd XDG_DATA_DIRS CHECK
		# BEGIN FUNCTIONS
		pvenv() {
			# starts a python virtual environment named after first arg and if a path to a requirements file is provided as second arg it installs it
			# "deactivate" leaves the venv
			local firstArg="$1"
			local activate="./$firstArg/bin/activate"
			python -m venv $firstArg 
			if [ ! -z "$2" ]; then
				source $activate && pip install -r $2 && echo "deactivate to leave"
			else
				source $activate && echo "deactivate to leave"
			fi
		}
		apt-remove() {
			# removes a package from apt and nix
			local firstArg="$1"
			sudo apt-get remove $(apt list --installed "$firstArg" 2>/dev/null | awk -F'/' 'NR>1{print $1}')
		}
		desktopFiles() {
			local firstArg="$1"
			echo "searching for $firstArg in $HOME/.nix-profile/share/applications/..."
			ls ~/.nix-profile/share/applications | grep "$firstArg"
			echo "searching for $firstArg in /usr/share/applications/..."
			ls /usr/share/applications | grep "$firstArg"
		} 
		pathappend() {
			for ARG in "$@"
			do
				if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
					PATH="${"$PATH:"}$ARG"
				fi
			done
		}	# END FUNCTIONS
		pathprepend() {
			for ARG in "$@"
			do
				if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
					PATH="$ARG${":$PATH"}"
				fi
			done
		}	# END FUNCTIONS


		# BEGIN ALIASES
		alias src="source"; 
		alias resrc="source ~/.zshrc";
		alias ...="../../"; 
		alias nrs="sudo nixos-rebuild switch"; 
		
		alias "g*"="git add *"; 
		alias gcm="git commit -m";
		alias gp="git push"; # conflicts with global-platform-pro, pari
		alias gpl="git pull";
		alias gco="git checkout";
		alias gbr="git branch";
		alias gcl="git clone";
		alias glog="git log";
		alias gdiff="git diff";
		alias gstat="git status";
		
		alias hms="rm -f ~/.config/mimeapps.list && home-manager switch";
		alias LS="ls -lAh";
		alias CD="cd";
		alias "cd.."="cd ..";
		alias "cd..."="cd ../..";
		alias "home manager"="home-manager";

		alias crontab-reboot-test="sudo rm /var/run/crond.reboot && sudo service cron restart"
		alias code=codium
		
		# END ALIASES
		'';

in
{
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
}