let 
    nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-24.11";
    pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShell {
    packages = with pkgs; [
        libgcc
        gnumake
        tmux
    ];

    shellHook = ''
        # Load virtual CAN module
        sudo modprobe vcan

        # Create virtual interface
        sudo ip link add dev vcan0 type vcan

        # Activate interface
        sudo ip link set up vcan0

        echo "Created VCAN interface 'vcan0'"
    '';
}