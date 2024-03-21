{ config, pkgs, home, ... }:

let
  environment = builtins.getEnv "ENVIRONMENT";
in
{
  imports =
    if environment == "work"
    then [ ./core.nix ./work.nix ]
    else [ ./core.nix ./personal.nix ];
}
