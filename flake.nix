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

    # macOS Support (master)
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Flake utils.
    flake-utils.url = "github:numtide/flake-utils";

    # Flake Parts
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

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

    # nix language server, used by vscode & neovim
    nil.url = "github:oxalica/nil/2023-05-09";

    # nixos-hardware support https://github.com/NixOS/nixos-hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # NUR (Nix User Repository)
    nur.url = "github:nix-community/NUR";

    # Snowfall Lib
    snowfall-lib.url = "github:snowfallorg/lib/dev";
    snowfall-lib.inputs.nixpkgs.follows = "nixpkgs";

    # Snowfall Flake
    flake.url = "github:snowfallorg/flake";
    flake.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # System Deployment
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # virtulenv, but for all languages
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake Hygiene
    flake-checker = {
      url = "github:DeterminateSystems/flake-checker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake-parts modules.
    flake-root.url = "github:srid/flake-root";
    mission-control.url = "github:Platonic-Systems/mission-control";

    # TODO separate secrets better..
    # secrets in a separate repository.
    #secrets = {
    #  url = "git+ssh://git@gitlab.cyber.ee/tansper/nix-secrets";
    #  flake = false;
    #};

    secrets = {
      url = "git+ssh://git@github.com/tafkamax/nix-secrets";
      flake = false;
    };

    # Yubikey Guide
    yubikey-guide = {
      url = "github:drduh/YubiKey-Guide";
      flake = false;
    };

    # GPG default configuration
    gpg-base-conf = {
      url = "github:drduh/config";
      flake = false;
    };
  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs = inputs:
    let
      # Create lib from information from current directory. e.g. if there is a lib directory present functions from there will we imported so you can use them. E.g. mkDeploy
      lib = inputs.snowfall-lib.mkLib {
        # Remove agenix from inputs to flake-utils-plus, as agenix does not have a default system target.
        inputs = builtins.removeAttrs inputs [ "agenix" ];
        src = ./.;
        snowfall = {
          meta = {
            name = "nixos-snowfall";
            title = "NixOS Snowfall systems";
          };
          # Name nixos-snowfall because it uses snowfallorg lib at its core.
          namespace = "nixos-snowfall";
        };
      };
    in
    lib.mkFlake {
      # Configure channels.
      channels-config = {
        # Allow unfree pkgs.
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-24.8.6"
        ];
      };

      # Import overlays from other inputs than just nixpkgs.
      overlays = with inputs; [
        flake.overlays.default
        agenix.overlays.default
      ];

      # Import modules from other inputs than just nixpkgs.
      systems.modules.nixos = with inputs; [
        # Add home-manager for managing /home
        home-manager.nixosModules.home-manager
        # Add agenix for managing secrets.
        agenix.nixosModules.default
        # Import non-flake config from secrets private-repository.
        (import secrets)
        # Add NUR (Nix User Repository), similar to AUR, as it is not as protected as nixpkgs.
        nur.nixosModules.nur
      ];


      # mkDeploy is defined under ./lib/deploy/default.nix
      deploy = lib.mkDeploy {
        inherit (inputs) self;
      };

      checks =
        builtins.mapAttrs
          (system: deploy-lib:
            deploy-lib.deployChecks inputs.self.deploy)
          inputs.deploy-rs.lib;
    };
}
