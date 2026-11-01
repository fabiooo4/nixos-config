{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    xournalpp

    (texliveBasic.withPackages (ps:
      with ps; [
        standalone
        varwidth
        eulervm
        scontents
        xcolor
        amsmath
        amsfonts
      ]))
  ];

  home.file = {
    ".config/xournalpp" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.userSettings.dotfiles.dotfilesDir}/.config/xournalpp";
    };
  };
}
