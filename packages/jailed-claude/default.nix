{ inputs, pkgs, ... }:
inputs.jailed-agents.lib.${pkgs.stdenv.hostPlatform.system}.makeJailedClaudeCode {
  name = "jailed-claude";
  pkg = pkgs.claude-code;
  extraPkgs = [
    pkgs.python3
    pkgs.nodejs_24
    pkgs.javaPackages.compiler.temurin-bin.jdk-25
    pkgs.ansible
    pkgs.python313Packages.pyaml
    pkgs.python313Packages.pyyaml
    pkgs.python313Packages.jinja2
  ];
  fwdEnv = [ "CLAUDE_CODE_OAUTH_TOKEN" ];
}
