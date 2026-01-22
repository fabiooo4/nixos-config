{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in {
  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
  ];

  options = {
    userSettings.music.spicetify = {
      stylix.enable = lib.mkEnableOption "Stylix auto theming";
    };
  };

  config = let
    cfg = config.userSettings.music.spicetify;
  in {
    programs.spicetify = {
      enable = true;
      enabledCustomApps = with spicePkgs.apps; [
        marketplace
      ];
      enabledExtensions = with spicePkgs.extensions; [
        adblockify
        hidePodcasts
        beautifulLyrics
        playNext
      ];

      theme = lib.mkIf (!cfg.stylix.enable) (lib.mkForce spicePkgs.themes.comfy);
      colorScheme = lib.mkIf (!cfg.stylix.enable) (lib.mkForce "Spotify");
    };
  };
}
