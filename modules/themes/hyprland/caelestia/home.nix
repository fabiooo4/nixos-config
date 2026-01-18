{
  lib,
  inputs,
  pkgs,
  osConfig,
  themeName,
  ...
}: {
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  config = let
    cfg = osConfig.theme.${themeName};
    enabled = osConfig.theme.active == themeName;
  in
    lib.mkIf enabled
    {
      programs.caelestia = {
        enable = true;
        systemd = {
          enable = false; # if you prefer starting from your compositor
          target = "graphical-session.target";
          environment = [];
        };
        settings = {
          bar.status = {
            showBattery = false;
          };
          paths.wallpaperDir = "~/Wallpapers";
        };
        cli = {
          enable = true; # Also add caelestia-cli to path
          settings = {
            theme.enableGtk = false;
          };
        };
      };

      wayland.windowManager.hyprland = {
        enable = true;

        package = null;
        portalPackage = null;
        settings = {
          exec-once = [
            "caelestia-shell -d"
          ];
          bindi = "Super, Super_L, global, caelestia:launcher";
          bindin = [
            # "Super, catchall, global, caelestia:launcherInterrupt"
            "Super, mouse:272, global, caelestia:launcherInterrupt"
            "Super, mouse:273, global, caelestia:launcherInterrupt"
            "Super, mouse:274, global, caelestia:launcherInterrupt"
            "Super, mouse:275, global, caelestia:launcherInterrupt"
            "Super, mouse:276, global, caelestia:launcherInterrupt"
            "Super, mouse:277, global, caelestia:launcherInterrupt"
            "Super, mouse_up, global, caelestia:launcherInterrupt"
            "Super, mouse_down, global, caelestia:launcherInterrupt"
          ];
        };
      };
    };
}
