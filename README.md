# NixOS System support for Raspberry Pi 3B+

Reusable Raspberry Pi board-support flake for NixOS.

This flake is intentionally focused on **board essentials only**: Raspberry Pi
boot/runtime defaults, firmware enablement, and installer-image plumbing.
Keep your own site policy and host preferences (users, secrets, SSH policy,
network credentials, enabled services) in your own flake modules.

## What It Exposes

- `nixosModules.default`: RPi board essentials (UART kernel params, redistributable firmware, SD rootfs defaults)
- `nixosModules.installerSdImage`: installer image support (`sd-image-aarch64`) and baseline iwd/wifi installer defaults
- `lib.withRpiEssentials`: combinator that appends board-essential module(s)
- `lib.withRpiInstallerEssentials`: combinator for board essentials + installer image module

## Example: Full System Configuration

Use this for a normal deployed system closure (`config.system.build.toplevel`).

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    rpi-3bplus.url = "github:virusdave/nixos-RaspberryPi-3BPlus";
  };

  outputs = { nixpkgs, rpi-3bplus, ... }: {
    nixosConfigurations.rpi = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";

      # Start with your own modules, then append RPi board essentials.
      modules = rpi-3bplus.lib.withRpiEssentials [
        ./your-base.nix
        ./your-host.nix
      ];
    };
  };
}
```

## Example: Inline Installer Image

This self-contained example can be dropped into a fresh repo to produce
an installer SD image quickly.

```nix
{
  description = "Minimal Raspberry Pi installer image";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    rpi-3bplus.url = "github:virusdave/nixos-RaspberryPi-3BPlus";
  };

  outputs = { nixpkgs, rpi-3bplus, ... }:
    let
      system = "aarch64-linux";
      modules = rpi-3bplus.lib.withRpiInstallerEssentials [
        ({ ... }: {
          networking.hostName = "rpi-installer";
          services.openssh.enable = true;
        })
      ];
    };
  };
}
```

Build the installer image with:

```sh
nix build .#nixosConfigurations.rpi-installer.config.system.build.sdImage
```
