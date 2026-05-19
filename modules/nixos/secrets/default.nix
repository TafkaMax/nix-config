{ config, inputs, ... }: {
  age.rekey = {
    # Every machine inherits this same Yubikey master identity
    masterIdentities = [
      ./yubikey-5nano.pub
      ./yubikey-5c-nano.pub
    ];

    storageMode = "local";
    # This dynamically generates a unique folder name for every host automatically
    # FIXED: Lock the path strictly to the Flake's root using inputs.self
    localStorageDir = inputs.self + "/secrets/rekeyed/${config.networking.hostName}";
  };
}
