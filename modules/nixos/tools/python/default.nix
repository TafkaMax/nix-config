{ options, config, lib, pkgs, ... }:

with lib;
with lib.nixos-snowfall;
let cfg = config.nixos-snowfall.tools.python;
in
{
  options.nixos-snowfall.tools.python = with types; {
    enable = mkBoolOpt false "Whether or not to enable Python.";
  };

  config =
    mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        (python311.withPackages (ps:
          with ps; [
          ])
        )
        poetry
      ];
    };
}
#  outputs = { self, nixpkgs, poetry2nix, ... } @ inputs:
#    let
#      system = "aarch64-darwin";
#      pkgs = import nixpkgs {
#        inherit system;
#      };
#     inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryEnv;
#      pythonEnv = mkPoetryEnv {
#        python = pkgs.python311;
#        projectDir = ./.;
#      };
#    in
#    {
#      devShells.${system}.default = pkgs.mkShell {
#        packages = with pkgs; [
#          ansible_2_14
#          awscli2
#          nodejs_18
#          nodePackages.prettier
#          poetry
#          pythonEnv
#          terraform
#          terraform-ls
#        ];
#      };
