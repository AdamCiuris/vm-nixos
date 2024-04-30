{  config, pkgs, ...}:{
	# msmtp --configure example@example.com
	# 2 step verification required
	# app password required
	programs.msmtp = {
    enable = true;
			extraConfig = ''
defaults
account gmail
host smtp.gmail.com
port 587
tls on
tls_starttls on
auth on
user paperpl88s
from paperpl88s@gmail.com
passwordeval cat /etc/msmtp-password
account default : gmail
			''; # weird formatting so it looks right in conf
  };
}