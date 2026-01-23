{
  lib,
  inputs,
  pkgs,
  config,
  osConfig,
  themeName,
  ...
}: {
  imports = [
    inputs.niri.homeModules.niri

    inputs.noctalia.homeModules.default
  ];

  config = let
    cfg = osConfig.theme.${themeName};
    enabled = osConfig.theme.active == themeName;

    # Helper to call noctalia-shell ipc commands as strings instead of lists of strings
    noctalia = cmd:
      [
        "noctalia-shell"
        "ipc"
        "call"
      ]
      ++ (pkgs.lib.splitString " " cmd);
  in
    lib.mkIf enabled
    {
      # Wallpaper
      home.file.".cache/noctalia/wallpapers.json" = {
        text = builtins.toJSON {
          defaultWallpaper = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/fabiooo4/wallpapers/main/wallhaven-1k27r1_1920x1080.png";
            hash = "sha256-o8twOuiBBa57sAECpZDM6u6OnZ9CVgbi8horSbmy/5M=";
          };
        };
      };

      # To see the diff of current settings and the gui modified ones run:
      # nix shell nixpkgs#jq nixpkgs#colordiff nixpkgs#wl-clipboard -c bash -c "diff -u <(jq -S . ~/.config/noctalia/settings.json) <(wl-paste | jq -S .) | colordiff"
      programs.noctalia-shell = {
        enable = true;
        settings = {
        };
      };

      # Keybinds
      programs.niri = {
        enable = true;
        settings = {
          spawn-at-startup = [
            {
              command = [
                "noctalia-shell"
              ];
            }
          ];
        };
        settings = {
          binds = with config.lib.niri.actions; {
            "XF86AudioLowerVolume".action.spawn = noctalia "volume decrease";
            "XF86AudioRaiseVolume".action.spawn = noctalia "volume increase";
            "XF86AudioMute".action.spawn = noctalia "volume muteOutput";
          };
        };
      };
    };
}
