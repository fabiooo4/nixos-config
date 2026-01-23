{
  lib,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  config = lib.mkIf config.userSettings.dotfiles.sioyek.enable {
    services.flatpak.packages = [
      "com.github.ahrm.sioyek"
    ];

    home.file = {
      ".config/sioyek" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.userSettings.dotfiles.dotfilesDir}/.config/sioyek";
      };
    };
  };
}
