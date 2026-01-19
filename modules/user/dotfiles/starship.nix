{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    pkgs.starship
  ];

  # Starship
  home.file = {
    ".config/starship.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.userSettings.dotfiles.dotfilesDir}/.config/starship.toml";
    };
  };
}
