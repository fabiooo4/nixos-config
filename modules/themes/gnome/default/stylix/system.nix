{
  lib,
  config,
  inputs,
  themeName,
  ...
}: {
  imports = [inputs.stylix.nixosModules.stylix];

  config = let
    cfg = config.theme.${themeName}.stylix;
  in
    lib.mkIf cfg.enable {
      stylix = {
        enable = true;

        polarity = "dark";
        # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

        image = cfg.wallpaper;
        cursor = cfg.cursor;
        fonts = {
          monospace = cfg.font;
          serif = config.stylix.fonts.monospace;
          sansSerif = config.stylix.fonts.monospace;
        };
      };
    };
}
