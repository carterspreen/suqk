{
  description = "Carter Spreen SUQK on IBM QPU";

  inputs = {
    # Official "nixpkgs" flake for NixOS 26.05
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";

    # Dr. Nicholas H. Stair's "qforte" library for Python
    qforte = {
      url = "github:nstair/qforte";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      qforte,
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      # FHS wrapper needed for conda
      fhs = pkgs.buildFHSEnv {
        # wrapper filename
        name = "suqk-fhs-wrapper";
        # wrapper packagelist
        targetPkgs =
          pkgs: with pkgs; [
            git
            neovim
            micromamba
          ];
        # setup conda and install qforte
        runScript = "${./scripts/setup.sh}";
      };
    in
    {
      # formatter for Nix files
      formatter.${system} = pkgs.nixfmt;

      # main development shell for SUQK
      devShells.${system}.default = pkgs.mkShell {
        shellHook = ''
          exec ${fhs.out}/bin/suqk-fhs-wrapper
        '';
      };
    };
}
