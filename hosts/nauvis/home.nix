{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: {
  config = {
    userSettings = {
      dotfiles = {
        enable = true;
        dotfilesDir = "${config.home.homeDirectory}/.dotfiles";

        kitty.enable = false;
        starship.enable = false;
        sioyek.enable = false;
      };
    };

    home.packages = with pkgs; [
      (
        lib.mkIf
        osConfig.systemSettings.rgb.enable
        openrgb
      )
    ];
  };
}
