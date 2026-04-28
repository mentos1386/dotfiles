{
  description = "Home Manager configuration";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
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
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          # Workaround for aarch64-darwin codesigning bug (nixpkgs#208951 / #507531):
          # fish binaries from the binary cache occasionally have invalid ad-hoc
          # signatures on Apple Silicon. Forcing a local rebuild ensures codesigning
          # is applied on this machine with a valid signature.
          overlays = [
            (_final: prev: {
              fish = prev.fish.overrideAttrs (_old: {
                # Bust the cache key so fish is always built locally rather than
                # substituted from the binary cache where the signature may be stale.
                NIX_FORCE_LOCAL_REBUILD = "darwin-codesign-fix";
              });
            })
          ];
        };
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
