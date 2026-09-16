{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };

      zenSource =
        (builtins.fromJSON
          (builtins.readFile ./packages/source.json))
        ."zen-browser";

      zenSourceForSystem =
        zenSource.sources.${system};

      zen-browser-unwrapped =
        pkgs.callPackage ./packages/zen/zen-browser-unwrapped.nix {
          version = zenSource.version;
          url = zenSourceForSystem.url;
          hash = zenSourceForSystem.hash;
        };

      zen-browser =
        pkgs.callPackage ./packages/zen/zen-browser.nix {
          inherit zen-browser-unwrapped;
        };
    in
    {
      packages.${system} = {
        zen-browser = zen-browser;
        zen-browser-unwrapped = zen-browser-unwrapped;
        default = zen-browser;
      };

      nixosConfigurations.Sharwesh =
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit zen-browser;
          };

          modules = [
            ./configuration.nix
          ];
        };
    };
}
