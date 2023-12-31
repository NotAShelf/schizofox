{
  description = "Schizofox flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      perSystem = {
        system,
        pkgs,
        config,
        ...
      }: {
        packages = {
          darkreader = pkgs.callPackage ./addons/darkreader.nix {};
        };
        formatter = pkgs.alejandra;
      };
      flake = {
        homeManagerModules = {
          schizofox = import ./hm-module.nix;
          default = self.homeManagerModules.schizofox;
        };
        homeManagerModule = self.homeManagerModules.default self;
      };
    };
}
