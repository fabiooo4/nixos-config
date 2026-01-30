{
  lib,
  pkgs,
  inputs,
  ...
}: {
  config = {
    programs.noctalia-shell.settings.templates.activeTemplates = [
      {
        id = "spicetify";
        active = true;
      }
    ];

    programs.spicetify = let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
    in {
      enable = true;
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
