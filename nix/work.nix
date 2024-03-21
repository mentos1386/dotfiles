{ lib, config, pkgs, ... }:

{
  home.username = "tine";
  home.homeDirectory = "/home/tine";

  programs.git.extraConfig.user.signingkey = lib.mkForce "~/.ssh/id_rsa";
}
