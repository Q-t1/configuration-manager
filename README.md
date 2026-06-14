# nixos-anywhere

```
nix run github:nix-community/nixos-anywhere -- --flake .#desktop --generate-hardware-config nixos-generate-config ./hosts/desktop/hardware-configuration.nix --target-host user@ip
```

```
nixos-rebuild switch --flake .#desktop --target-host user@ip --sudo --ask-sudo-password
```
