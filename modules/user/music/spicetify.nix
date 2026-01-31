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

      theme = lib.mkDefault spicePkgs.themes.comfy;
      colorScheme = lib.mkDefault "Spotify";
    };
  };
}
