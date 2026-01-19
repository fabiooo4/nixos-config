{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    pkgs.xournalpp
  ];

  home.file = {
    ".config/xournalpp" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.userSettings.dotfiles.dotfilesDir}/.config/xournalpp";
    };
  };
}
