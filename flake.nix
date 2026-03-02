{
  description = "Raspberry Pi board-support modules and combinators for NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs }: {
    lib = {
      withRpiEssentials = modules:
        modules ++ [ self.nixosModules.default ];

      withRpiInstallerEssentials = modules:
        self.lib.withRpiEssentials (modules ++ [ self.nixosModules.installerSdImage ]);
    };

    nixosModules = {
      default = import ./modules/essential.nix;
      installerSdImage = import ./modules/installer-sd-image.nix;
    };
  };
}
