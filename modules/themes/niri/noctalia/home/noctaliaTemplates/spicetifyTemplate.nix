{
  lib,
  pkgs,
  inputs,
  osConfig,
  themeName,
  ...
}: {
  config = let
    cfg = osConfig.theme.${themeName};
    enabled = osConfig.theme.active == themeName;
  in
    lib.mkIf enabled
    {
      programs.noctalia-shell.settings.templates.activeTemplates = [
        {
          id = "spicetify";
          active = true;
        }
      ];

      programs.spicetify = let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
      in {
        theme = {
          src = lib.mkForce spicePkgs.themes.comfy;

          injectCss = true;
          injectThemeJs = true;
          replaceColors = true;
          overwriteAssets = true;
        };

        # colorScheme = lib.mkForce "Comfy";
      };
    };
}
