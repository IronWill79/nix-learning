let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/dc2e0028d274394f73653c7c90cc63edbb696be1.tar.gz";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in
rec {
  hello = pkgs.callPackage ./hello.nix { audience = "people"; };
  hello-folks = hello.override { audience = "folks"; };
}
