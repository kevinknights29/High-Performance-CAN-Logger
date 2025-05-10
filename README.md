# High-Performance-CAN-Logger

A High-performance CAN Logger to learn more about ECUs communication for Robotics

## Overview

### What is a CAN Logger?

A CAN logger is a device designed to record and store data transmitted over a CAN (Controller Area Network) bus system, which is commonly used in vehicles and industrial machinery for communication between electronic control units (ECUs).

### CAN interfaces can be simulated with SocketCAN

```bash
sudo modprobe vcan  # Load virtual CAN module
sudo ip link add dev vcan0 type vcan  # Create virtual interface
sudo ip link set up vcan0  # Activate interface
```

## Getting Started

### 1. Install Nix

To install Nix on your system, please refer to: [Install Nix](https://nix.dev/install-nix#install-nix).

### 2. Run `nix-shell` in your terminal

### 3. Run `make` in your nix-shell to compile source

### 4. Run CAN Logger with `make run`
