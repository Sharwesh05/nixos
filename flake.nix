{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    linux-omen-module = {
      url = "github:Sharwesh05/linux-omen-module/74471ebdeec1a1292d6688ef2abefe2896971485";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, linux-omen-module, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;

        overlays = [
          (import ./overlays/opencode.nix)
        ];
      };

      sources =
        builtins.fromJSON
          (builtins.readFile ./packages/source.json);

      # -------------------------
      # Zen Browser
      # -------------------------
      zenSource = sources."zen-browser";

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
      
      omen-tools =
        pkgs.callPackage ./packages/linux-omen-module/tools.nix {
          inherit linux-omen-module;
        };

    in
    {
      packages.${system} = {
        zen-browser = zen-browser;
        zen-browser-unwrapped = zen-browser-unwrapped;
        omen-tools = omen-tools;
      };

      nixosConfigurations.Sharwesh =
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit 
              zen-browser 
              linux-omen-module
              omen-tools;
          };

          modules = [
            ./configuration.nix

            {
              nixpkgs.overlays = [
                (import ./overlays/opencode.nix)
              ];
            }
          ];
        };
        
    };
}