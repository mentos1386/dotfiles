{ config, pkgs, home, ... }:

let
  environment = builtins.getEnv "ENVIRONMENT";
in
{
  imports =
    if environment == "work"
    then [ ./core.nix ./work.nix ]
    else if environment == "personal-macos" 
    then [ ./core.nix ./personal-macos.nix ]
    else [ ./core.nix ./personal.nix ];
}
