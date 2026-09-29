{ inputs, pkgs, ... }:
inputs.jailed-agents.lib.${pkgs.stdenv.hostPlatform.system}.makeJailedClaudeCode {
  name = "jailed-claude";
  extraPkgs = [ pkgs.python3 ];
}
