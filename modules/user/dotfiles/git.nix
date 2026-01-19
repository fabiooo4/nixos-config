{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    pkgs.git
  ];

  home.file = {
    ".config/git" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.userSettings.dotfiles.dotfilesDir}/.config/git";
    };
  };
}
