# My NixOS configuration
## Installation
<!-- ```bash
nix-shell -p git --command "nix run --experimental-features 'nix-command flakes' github:fabiooo4/nixos-config"
``` -->

To install this NixOS configuration, follow these steps:

1. Clone the repo
```bash
nix-shell -p git --command "mkdir -p .config/nixconfig && git clone https://github.com/fabiooo4/nixos-config.git ~/.config/nixconfig"
```

2. Create a new host inside the hosts folder by copying the template. The name of the new folder should be your hostname.
```bash
cp -r ~/.config/nixconfig/hosts/template ~/.config/nixconfig/hosts/<your-hostname>
```
```
hosts/
├── template/
└── your-hostname/
    ├── configuration.nix
    ├── default.nix
    └── home.nix
```

3. Copy the hardware-configuration.nix file to the new host folder
```bash
sudo cp /etc/nixos/hardware-configuration.nix ~/.config/nixconfig/hosts/$(hostname)/hardware-configuration.nix
```

4. Edit the new host files as needed

5. Rebuild your NixOS system with the new configuration
```bash
sudo nixos-rebuild switch --flake .config/nixconfig#your-hostname
```

6. Reboot your system to apply all changes
```bash
reboot
```
