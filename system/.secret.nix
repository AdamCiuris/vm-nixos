{ config, pkgs, ... }:
{
  # stop tracking changes to a file, start tracking changes to a file
  # git update-index --assume-unchanged FILE_NAME
  # git update-index --no-assume-unchanged FILE_NAME
    environment.systemPackages = with pkgs; [
    ];
}