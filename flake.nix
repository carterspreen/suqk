{
  description = "Carter Spreen SUQK on IBM QPU";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";

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

      fhs = pkgs.buildFHSEnv {
        name = "suqk-fhs-wrapper";
        targetPkgs =
          pkgs: with pkgs; [
            micromamba
          ];
      };
    in
    {
      # official formatter for Nix files
      formatter.${system} = pkgs.nixfmt;

      # community formatter for Nix files
      # formatter.${system} = pkgs.alejandra;

      # main development shell for SUQK
      devShells.${system}.default = pkgs.mkShell {
        shellHook = ''
          exec ${fhs.out}/bin/suqk-fhs-wrapper
        '';
      };
    };
}
