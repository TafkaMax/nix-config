{ inputs, ... }:
{ snowfallFlake }:
inputs.agenix-rekey.configure {
  userFlake = inputs.self;
  inherit (snowfallFlake) nixosConfigurations;
}
