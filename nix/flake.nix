{
  description = "Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        legacyPackages = {
          homeConfigurations = {
            "tinejozelj" = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;

              modules = [
                ./core.nix
                ./work.nix
              ];
            };
            "tine" = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;

              modules =
                if system == "aarch64-darwin" then
                  [
                    ./core.nix
                    ./personal-macos.nix
                  ]
                else
                  [
                    ./core.nix
                    ./personal.nix
                  ];
            };
          };
        };
      }
    );
}
