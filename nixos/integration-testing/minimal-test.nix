let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/archive/dc2e0028d274394f73653c7c90cc63edbb696be1.tar.gz";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.testers.runNixOSTest {
  name = "minimal-test";
  nodes.machine = { config, pkgs, ... }: {
    users.users.ironwill = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      packages = with pkgs; [
        firefox
        tree
      ];
    };

    system.stateVersion = "24.05";
  };
  
  testScript = { nodes, ... }: ''
    machine.wait_for_unit("default.target")
    machine.succeed("su -- root -c 'echo `system-features = nixos-test benchmark big-parallel kvm` >> /etc/nix/nix.conf'")
    machine.succeed("su -- ironwill -c 'which firefox'")
    machine.fail("su -- root -c 'which firefox'")
  '';
}
