{
  description = "Quarto with batteries included for rendering documents based on the TexNative template.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let

    system         = "x86_64-linux";
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

    packages.x86_64-linux.quarto-for-quiqr =
      let
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        qname = "q4q";
        qscript = pkgs.writeShellScriptBin qname ''
            ${pkgs.quarto}/bin/quarto render "''${1}"
            echo "''${1%.*}".pdf
        '';
        qBuildInputs = with pkgs; [ quarto ];

      in pkgs.symlinkJoin {
        name = qname;
        paths = [ qscript ] ++ qBuildInputs;
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = "wrapProgram $out/bin/${qname} --prefix PATH : $out/bin";
      };

      #    packages.x86_64-linux.quarto-for-quiqr2 =
      #      pkgs.writeShellScriptBin "quarto-for-quiqr2" ''
      #        ${pkgs.quarto}/bin/quarto render "''${1}"
      #        echo "''${1%.*}".pdf
      #      '';
  };
}
