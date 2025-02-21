{
  description = "Quarto with batteries included for rendering documents based on the TexNative template.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {

    packages.x86_64-linux.quarto = nixpkgs.legacyPackages.x86_64-linux.quarto;

    packages.x86_64-linux.default = self.packages.x86_64-linux.quarto;

  };
}
