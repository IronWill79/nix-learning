To create a nixos configuration that is used for the NixOS minimal ISO image:

```sh
  nix-shell -I nixpkgs=channel:nixos-24.05 -p "$(cat <<EOF
    let
      pkgs = import <nixpkgs> { config = {}; overlays = []; };
      iso-config = pkgs.path + /nixos/modules/installer/cd-dvd/installation-cd-minimal.nix;
      nixos = pkgs.nixos iso-config;
    in nixos.config.system.build.nixos-generate-config
  EOF
  )"
```

Then in the `nix-shell`, run:

```sh
[nix-shell:~]$ nixos-generate-config --dir ./
```

Note: without the --dir, the generated configuration file is written to
`/etc/nixos/configuration.nix`, which typically requires `sudo` permissions.
