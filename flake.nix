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
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    # There are many ways to reference flake inputs. The most widely used is github:owner/name/reference,
    # which represents the GitHub repository URL + branch/commit-id/tag.

    # Official NixOS package source, using nixos's stable branch by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Required for php81
    nixpkgs-old.url = "github:nixos/nixpkgs/nixos-25.05";

    # macOS Support (master)
    darwin.url = "github:nix-darwin/nix-darwin";
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
      url = "github:nix-community/home-manager/release-26.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secrets management
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # yubikey support for secrets
    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix language server, used by vscode & neovim
    nil.url = "github:oxalica/nil/2025-06-13";

    # nixos-hardware support https://github.com/NixOS/nixos-hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # NUR (Nix User Repository)
    nur.url = "github:nix-community/NUR";

    # Snowfall Lib
    snowfall-lib = {
      url = "github:TafkaMax/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Snowfall Flake
    flake = {
      url = "github:TafkaMax/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # System Deployment
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    # virtulenv, but for all languages
    devshell = {
      url = "github:numtide/devshell";
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

    # snowfall-lib docs
    snowfall-docs = {
      url = "github:TafkaMax/docs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
    };
  };

  # The `outputs` function will return all the build results of the flake.
  # A flake can have many use cases and different types of outputs,
  # parameters in `outputs` are defined in `inputs` and can be referenced by their names.
  # However, `self` is an exception, this special parameter points to the `outputs` itself (self-reference)
  # The `@` syntax here is used to alias the attribute set of the inputs's parameter, making it convenient to use inside the function.
  outputs =
    inputs:
    let
      # Create lib from information from current directory. e.g. if there is a lib directory present functions from there will we imported so you can use them. E.g. mkDeploy
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
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

      # 1. Generate core Snowfall flake outputs and store them in a variable
      snowfallFlake = lib.mkFlake {
        channels-config = {
          # Configure channels.
          allowUnfree = true; # Allow unfree pkgs.
          permittedInsecurePackages = [
            "python3.13-pypdf3-1.0.6"
            "docker-28.5.2"
          ];
        };

        overlays = with inputs; [
          flake.overlays.default
          agenix.overlays.default
          snowfall-docs.overlays.default
        ]; # Import overlays from other inputs than just nixpkgs.

        systems.modules.nixos = with inputs; [
          home-manager.nixosModules.home-manager # Add home-manager for managing /home
          agenix.nixosModules.default # Add agenix for managing secrets.
          agenix-rekey.nixosModules.default # Agenix rekey for yubikey support for agenix
          (import secrets)
          nur.modules.nixos.default # Add NUR (Nix User Repository), similar to AUR, as it is not as protected as nixpkgs.
        ]; # Import modules from other inputs than just nixpkgs.

        deploy = lib.mkDeploy {
          inherit (inputs) self;
        }; # mkDeploy is defined under ./lib/deploy/default.nix

        checks = builtins.mapAttrs (
          system: deploy-lib: deploy-lib.deployChecks inputs.self.deploy
        ) inputs.deploy-rs.lib;

        outputs-builder = channels: { formatter = channels.nixpkgs.nixfmt; };
      };
    in
    # 2. Shallow merge everything together.
    # This attaches agenix-rekey commands onto Snowfall's configurations.
    snowfallFlake
    // {
      self = inputs.self;
      # FIXED: Expose your hosts to the CLI tool exactly where it expects to find them!
      agenix-rekey = inputs.agenix-rekey.configure {
        userFlake = inputs.self;
        inherit (snowfallFlake) nixosConfigurations;
      };
    };
}
