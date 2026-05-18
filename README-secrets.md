# Secrets storage

There are many ways how to do secret storage in nixos. Currently I have chosen to use the following method.

- Secrets are stored in a separate private repository. Encrypted using Agenix.
  - https://github.com/ryantm/agenix
- The repository is added as an `input` to `flake.nix` config as a non-flake.
  - ```    # secrets in a separate repository.
    secrets = {
      url = "git+ssh://git@github.com/tafkamax/nix-secrets";
      flake = false;
    };
    ```
- Add the `input` to `outputs` to import it. **NB! your outputs may differ.**
  - ```  outputs =
    inputs@{ self
    , nixpkgs
    , home-manager
    , secrets
    , ...
    }:
    ```
- We import the non-flake under `modules`. **NB! Parentheses need to be added.**
  - `(import secrets)`

## Private secret repository

The layout for the secret repository I use is this.

```
README.md
encrypt/
default.nix
secrets.nix
```

Replace `$secret_name` with a variable.

```
#default.nix
{ ... }:

{
  age.secrets.$secret_name.file = ./encrypt/$secret_name.age;
}
```

Replace `$username`, `$root-hostname` and `$secret_name` with your variables.

```
#secrets.nix
# This file is not imported into your NixOS configuration. It is only used for the agenix CLI.

let
  # get my ssh public key for agenix by command:
  #     cat ~/.ssh/ed25519.pub
  # if you do not have one, you can generate it by command:
  #     ssh-keygen -t ed25519
  $username = "user pubkey";
  users = [ $username ];

  # get system's ssh public key by command:
  #    cat /etc/ssh/ssh_host_ed25519_key.pub
  $root-hostname = "root pubkey";
  systems = [ $root-hostname ];
in
{
  "./encrypt/$secret_name.age".publicKeys = [ $username $root-hostname ];
}
```

## Actually create the encrypted file

If you have agenix installed:

`agenix -e ./encrypt/$secret_name.age`

If you don't have agenix installed:

`bash nix run github:ryantm/agenix -- -e ./encrypt/$secret_name.age`

## 2026 update to use agenix-rekey

In 2026 I updated the repo to use `agenix-rekey` and learned a lot and it is super frustrating.

**NB!** Some commands I ran in any random order. Might make this more coherent in the future.

1. If you lose the SSH key like me or forget that running under sudo doesnt have access to **yubikey** ssh keys that are run from normal user agent then these commands might help.
  1. `rage -e -R yubikey_ssh_rsa.pub -o ./encrypt/ai-api-key.age secret.txt`
    1. I ran this command in my `secrets` repository. I used `nix shell nixpkgs#rage` to get access to the rage CLI tool. I used `ssh-add -L > yubikey_ssh_rsa.pub` to get the pub key from a working setup.
