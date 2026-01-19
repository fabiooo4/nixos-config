{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    userSettings.dotfiles = {
      enable = lib.mkEnableOption "Enable dotfiles symlink into .config and clone my dotfiles repo if it is not present in the home directory.";

      dotfilesDir = lib.mkOption {
        description = "Set the path to the dotfiles directory. It will be cloned there if it does not exist.";
        type = lib.types.path;
      };

      kitty.enable = lib.mkOption {
        description = "Enable Kitty terminal emulator configuration from dotfiles.";
        type = lib.types.bool;
        default = true;
      };
    };
  };

  config = let
    cfg = config.userSettings.dotfiles;
  in
    lib.mkIf cfg.enable {
      home.activation = {
        # Clone dotfiles repo if it doesn't exist to not break symlinks
        cloneDotfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
          if ! [[ -d "${cfg.dotfilesDir}" ]]; then
            ${pkgs.git}/bin/git clone https://github.com/fabiooo4/dotfiles.git ${cfg.dotfilesDir}
            ${pkgs.git}/bin/git clone https://github.com/fabiooo4/Neovim.git ${cfg.dotfilesDir}/.config/nvim
                   cd ${cfg.dotfilesDir}
            ${pkgs.git}/bin/git remote remove origin
            ${pkgs.git}/bin/git remote add origin git@github.com:fabiooo4/dotfiles.git
                   cd ${cfg.dotfilesDir}/.config/nvim
            ${pkgs.git}/bin/git remote remove origin
            ${pkgs.git}/bin/git remote add origin git@github.com:fabiooo4/Neovim.git
                 fi
        '';
      };
    };
}
