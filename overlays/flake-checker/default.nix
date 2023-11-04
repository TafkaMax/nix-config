{ ... }:
final: prev:
{ }
#{ flake-checker, ... }:
#
#final: prev:
#{
#  inherit (flake-checker.packages.${prev.system}) flake-checker;
#}
