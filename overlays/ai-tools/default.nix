{ channels, ... }:
final: prev: {
  inherit (channels.nixpkgs-unstable) claude-code claude-agent-acp;
}
