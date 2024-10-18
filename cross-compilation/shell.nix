let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/dc2e0028d274394f73653c7c90cc63edbb696be1.tar.gz";
  pkgs = (import nixpkgs {}).pkgsCross.aarch64-multiplatform;
in

# callPackage is needed due to https://github.com/NixOS/nixpkgs/pull/126844
pkgs.pkgsStatic.callPackage ({ mkShell, zlib, pkg-config, file }: mkShell {
  # these tools run on the build platform, but are configured to target
  nativeBuildInputs = [ pkg-config file ];
  # libraries needed for the host platform
  buildInputs = [ zlib ];
}) {}
