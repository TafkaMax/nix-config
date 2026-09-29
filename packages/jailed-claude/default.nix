{ inputs, pkgs, ... }:
inputs.jailed-agents.lib.${pkgs.stdenv.hostPlatform.system}.makeJailedClaudeCode {
  name = "jailed-claude";
  pkg = pkgs.claude-code;
  extraPkgs = [ pkgs.python3 ];
  fwdEnv = [ "CLAUDE_CODE_OAUTH_TOKEN" ];
}
