{ channels, ... }:
final: prev: {
  inherit (channels.unstable) flameshot;
}
