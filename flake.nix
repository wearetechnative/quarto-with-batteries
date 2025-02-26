{
  description = "Quarto with batteries included for rendering documents based on the TexNative template.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let

    system         = "x86_64-linux";
      #old-quarto-pkgs = nixpkgs.legacyPackages.${system};
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
        ];
      };
    };

    pkgs  = import nixpkgs { inherit system; overlays = [ quarto-overlay ];};


  in
  {
    packages.x86_64-linux.quarto = pkgs.quarto;
    packages.x86_64-linux.default = pkgs.quarto;
  };
}
