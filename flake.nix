{
  description = "A dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        # Only compile time deps
        nativeBuildInputs = [
          pkgs.zola
        ];

        # Compile & runtime deps
        buildInputs = [
        ];

        damszew-dev = pkgs.stdenv.mkDerivation
          {
            name = "Zola build";

            src = self;

            inherit nativeBuildInputs;

            installPhase = ''
              zola build --output-dir $out/public
            '';

          };

        dockerImage = pkgs.dockerTools.streamLayeredImage {
          name = "ghcr.io/damszew/damszew-dev";
          tag = "latest";
          contents = [
            pkgs.static-web-server
            damszew-dev
          ];
          config = {
            Cmd = [ "static-web-server" "--root" "public" ];
          };
        };
      in
      {
        # `nix flake check`
        checks = {
          inherit damszew-dev;
        };

        # `nix build .`
        packages = {
          inherit damszew-dev dockerImage;

          default = damszew-dev;
        };

        # `nix run .`
        # apps.default = flake-utils.lib.mkApp {
        #   drv = blog_server;
        # };

        # `nix develop`
        devShells.default = pkgs.mkShell {
          inherit buildInputs nativeBuildInputs;
        };
      }
    );
}
