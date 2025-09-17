# Special thanks to @Sk7Str1p3, @mourogurt, @kaeeraa, @mctrxw for help with this flake and packages
{
  description = ''
    Millennium - an open-source low-code modding framework to create,
    manage and use themes/plugins for the desktop Steam Client
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    self.submodules = true; # Requires *Nix* >= 2.27
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    { nixpkgs, self, ... }:
    let
      inherit (self.packages.${system}) millennium;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      version =
        let
          base = builtins.replaceStrings [ "# current version of millennium" "v" "\n" ] [ "" "" "" ] (
            builtins.readFile ./version
          );
        in
        if self ? shortRev then "${base}-${self.shortRev}" else if self ? dirtyShortRev then "${base}-${self.dirtyShortRev}" else "${base}-dirty";

      overlays.default = final: prev: {
        inherit system;
        steam-millennium = final.steam.override (prev: {
          extraPkgs = pkgs: [ pkgs.git ];
          extraProfile = ''
            export LD_LIBRARY_PATH="${millennium}/lib/millenium/''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
            export LD_PRELOAD="${millennium}/lib/millennium/libmillennium_x86.so''${LD_PRELOAD:+:$LD_PRELOAD}"
          ''
          + (prev.extraProfile or "");
        });
      };

      devShells.${system}.default = import ./shell.nix { inherit pkgs; };

      packages.${system} = {
        default = self.packages.${system}.millennium;
        millennium = pkgs.callPackage ./nix/millennium.nix { inherit self; };
        shims = pkgs.callPackage ./nix/typescript/shims.nix { inherit self; };
        assets = pkgs.callPackage ./nix/assets.nix { inherit self; };
        python = {
          millennium = pkgs.callPackage ./nix/python/millennium.nix { inherit self; };
          core-utils = pkgs.callPackage ./nix/python/core-utils.nix { inherit self; };
        };
        # basic script to update pnpm hashes in the shims and assets package definitions
        # usage: nix run .#update-pnpm-hashes
        update-pnpm-hashes = pkgs.callPackage ./nix/update.nix { };
      };
    };
}
