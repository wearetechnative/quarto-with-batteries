{ pkgs, ... }:
let

  qname = "q4q";

  qscript = pkgs.writeShellScriptBin qname ''
    ${pkgs.quarto}/bin/quarto render "''${1}"
    echo "''${1%.*}".pdf
    '';

  qBuildInputs = with pkgs; [
    quarto
    texlive.combined.scheme-full

    #rPackages.tinytex
    (python3.withPackages (python-pkgs: with python-pkgs; [
      pyyaml
    ]
    ))
  ];

in pkgs.symlinkJoin {
    name = qname;
    paths = [ qscript ] ++ qBuildInputs;
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = "wrapProgram $out/bin/${qname} --prefix PATH : $out/bin";
}
