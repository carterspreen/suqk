{
  description = "Carter Spreen SUQK on IBM QPU";

  inputs = {
    # Official "nixpkgs" flake for NixOS 26.05
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";

    # Dr. Nicholas H. Stair's "qforte" library for Python
    qforte = {
      url = "git+https://github.com/nstair/qforte.git?submodules=1";
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

      # this is super important. the nixpkgs version of micromamba is broken.
      # TODO: submit a PR to nixpkgs to fix this, then remove this override.
      micromambaFixed = pkgs.micromamba.overrideAttrs (_previous: {
        installPhase = ''
          mkdir -p "$out/bin"

          cp \
            ${pkgs.mamba-cpp}/bin/.mamba-wrapped \
            "$out/bin/micromamba"
        '';
      });
    in
    {
      # formatter for Nix files
      formatter.${system} = pkgs.nixfmt;
      #formatter.${system} = pkgs.alejandra;

      # development shells for SUQK
      devShells.${system} = {
        # main development shell for SUQK, with micromamba and qforte
        default = pkgs.mkShell {
          name = "suqk-dev-shell";

          packages = with pkgs; [
            git
            neovim
            bashInteractive
            micromambaFixed
          ];

          shellHook = ''
            # use strict mode
            set -euo pipefail

            # determine the project root and qforte source directory
            project_root="$(git rev-parse --show-toplevel)"
            qforte_dir="$project_root/.qforte"
            qforte_nix_source=${qforte}

            # set the micromamba root prefix to a hidden directory in the project root
            export MAMBA_ROOT_PREFIX="$project_root/.mamba"

            # copy the qforte source from the nix store to the project root
            if [[ ! -d "$qforte_dir" ]]; then
              cp -R "$qforte_nix_source" "$qforte_dir"
              chmod -R u+w "$qforte_dir"
            fi

            # create the micromamba environment if it doesn't exist
            if ! micromamba run --name suqk true >/dev/null 2>&1; then
                micromamba create --yes --file "$project_root/environment.yml"
            fi

            # build and install qforte in the micromamba environment if it isn't already installed
            if ! micromamba run --name suqk python -c "import qforte" >/dev/null 2>&1; then
                (
                    cd "$qforte_dir"
                    micromamba run --name suqk python setup.py develop
                )
            fi

            # activate the micromamba environment
            eval "$(micromamba shell hook --shell bash)"
            micromamba activate suqk

            # unset local variables before dropping into the development shell
            unset project_root qforte_dir qforte_nix_source
          '';
        };
      };
    };
}
