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
        theme = lib.mkForce spicePkgs.themes.comfy;
        # colorScheme = lib.mkForce "Comfy"; TODO: Fix whole template
      };
    };
}
