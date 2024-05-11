{ config, pkgs, ... }:
{
  programs.openvpn3.enable = true;
  services.openvpn.servers = {
    me = {
      config = '' config /etc/openvpn/server.ovpn '';
    };
  };
}