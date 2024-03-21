{ config, pkgs, home, ... }:
with import <nixpkgs> { };
with lib;
let
  environment = builtins.getEnv "DOTFILES_ENV";
in
{
  imports =
    if environment != "" then
      if environment == "personal" then
        lib.info "loading PERSONAL home manager environment"
          [ ./core.nix ./personal.nix ]
    else
      if environment == "work" then
        lib.info "loading WORK home manager environment"
          [ ./core.nix ./work.nix ]
      else
        lib.warn "DOTFILES_ENV is not one of 'personal' or 'work', ONLY core home environment will be available!" [ ]
    else
      lib.warn "DOTFILES_ENV not specified, ONLY core home environment will be available!" [ ];
}
