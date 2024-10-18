/nixos

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

To create a NixOS virtual machine with `nix-build`, run:

```sh
nix-build '<nixpkgs/nixos>' -A vm -I nixpkgs=channel:nixos-24.05 -I nixos-config=./configuration.nix
```

Running the virtual machine

```sh
QEMU_KERNEL_PARAMS=console=tty50 ./result/bin/run-nixos-vm -nographic; reset
```

To create a nixos configuration with Gnome:

```sh
  nix-shell -I nixpkgs=channel:nixos-24.05 -p "$(cat <<EOF
    let
      pkgs = import <nixpkgs> { config = {}; overlays = []; };
      iso-config = pkgs.path + /nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix;
      nixos = pkgs.nixos iso-config;
    in nixos.config.system.build.nixos-generate-config
  EOF
  )"
```
