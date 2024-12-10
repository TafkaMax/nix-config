# Snowfall Lib provides access to additional information via a primary argument of
# your overlay.
{
  # Channels are named after NixPkgs instances in your flake inputs. For example,
  # with the input `nixpkgs` there will be a channel available at `channels.nixpkgs`.
  # These channels are system-specific instances of NixPkgs that can be used to quickly
  # pull packages into your overlay.
  channels
, # Inputs from your flake.
  inputs
, ...
}:
(final: prev: {
  gnome-keyring = prev.gnome-keyring.overrideAttrs (oldAttrs: {
    configureFlags = oldAttrs.configureFlags or [ ] ++ [
      "--disable-ssh-agent"
    ];
  });
})
