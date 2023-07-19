{
  description = "NixOS configuration.";

  ##################################################################################################################
  #
  # Want to know Nix in details? Looking for a beginner-friendly tutorial?
  # Check out [NixOS & Nix Flakes - A Guide for Beginners](https://thiscute.world/en/posts/nixos-and-flake-basics/)!
  #
  ##################################################################################################################

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    # There are many ways to reference flake inputs. The most widely used is github:owner/name/reference,
    # which represents the GitHub repository URL + branch/commit-id/tag.

    # Official NixOS package source, using nixos's stable branch by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Flake utils.
    flake-utils.url = "github:numtide/flake-utils";

    # Common Grub2 themes
    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # generate iso/qcow2/docker/... image from nixos configuration
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secrets management
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secrets in a separate repository.
    secrets = {
      url = "git+ssh://git@gitlab.cyber.ee/tansper/nix-secrets";
      flake = false;
    };

    # nix language server, used by vscode & neovim
    nil.url = "github:oxalica/nil/2023-05-09";

    # nixos-hardware support https://github.com/NixOS/nixos-hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # NUR (Nix User Repository)
    nur.url = "github:nix-community/NUR";
  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs =
    inputs@{ self
    , nixpkgs
    , home-manager
    , nixos-generators
    , nixos-hardware
    , agenix
    , secrets
    , nur
    , ...
    }:

    let
      x64_system = "x86_64-linux";
      x64_specialArgs = {
        # use unstable branch for some packages to get the latest updates
        pkgs-unstable = import inputs.nixpkgs-unstable {
          system = x64_system; # refer the `system` parameter form outer scope recursively
          # To use chrome, we need to allow the installation of non-free software
          config.allowUnfree = true;
        };
      } // inputs;
      # Tafka Lenovo E495
      tafka_e495_modules = [
        ./hosts/tafka-e495

        # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
        nixos-hardware.nixosModules.lenovo-thinkpad-e495

        # Import non-flake config from secrets private-repository.
        (import secrets)

        # add agenix
        agenix.nixosModules.default

        # add nur modules
        nur.nixosModules.nur

        # add home manager
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          # Merge together extra args.
          home-manager.extraSpecialArgs = x64_specialArgs;
          home-manager.users.tafka.imports = [
            ./home/linux/wayland.nix
            nur.hmModules.nur
          ];
        }
      ];
      # Tansper 3106
      tansper_3106_modules = [
        ./hosts/tansper-3106

        # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
        nixos-hardware.nixosModules.common-cpu-intel
        nixos-hardware.nixosModules.common-gpu-amd

        # Import non-flake config from secrets private-repository.
        (import secrets)

        # add agenix
        agenix.nixosModules.default

        # add nur modules
        nur.nixosModules.nur

        # add home manager
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          # Merge together extra args.
          home-manager.extraSpecialArgs = x64_specialArgs;
          home-manager.users.tafka.imports = [
            ./home/linux/wayland.nix
            nur.hmModules.nur
          ];
        }
      ];
    in
    {
      nixosConfigurations = let system = x64_system; specialArgs = x64_specialArgs; in {
        tafka-e495 = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = tafka_e495_modules;
        };
        tansper-3106 = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = tansper_3106_modules;
        };
      };

      formatter = {
        x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      };

      packages.x86_64-linux =
        #   https://github.com/nix-community/nixos-generators
        let system = x64_system; specialArgs = x64_specialArgs; in {
          # Tafka E495 is a physical machine, so we need to generate an iso image for it.
          tafka-e495 = nixos-generators.nixosGenerate {
            inherit system specialArgs;
            modules = tafka_e495_modules;
            format = "iso";
          };
          # Tansper 3106 is a physical machine, so we need to generate an iso image for it.
          tansper-3106 = nixos-generators.nixosGenerate {
            inherit system specialArgs;
            modules = tansper_3106_modules;
            format = "iso";
          };
        };
    };
}
