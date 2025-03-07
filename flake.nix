{
  description = "Quarto with batteries included for rendering documents based on the TexNative template.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {nixpkgs, ...}:
  let
    quarto-overlay  = final: prev: {

      quarto = prev.quarto.override {
        extraRPackages = [
            prev.rPackages.reticulate
        ];
        extraPythonPackages = ps: with ps; [
          plotly
          numpy
          pandas
          matplotlib
          tabulate
          pyyaml
        ];
      };
    };

    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ] (system:
        function (import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            quarto-overlay
          ];
        }));

  in {
    packages = forAllSystems (pkgs: {
      default = pkgs.callPackage ./package.nix {};
      quarto = pkgs.quarto;
      quarto-for-quiqr = pkgs.callPackage ./package.nix {};
    });
  };
}
