{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options = let
    remapSettings = pkgs.formats.yaml {};
  in {
    systemSettings = {
      remaps = lib.mkOption {
        description = "List of key remaps.";
        default = null;
        type = lib.types.nullOr (lib.types.submodule {
          freeformType = remapSettings.type;
        });
        example = ''
          {
            modmap = [
              {
                name = "Global";
                remap = {
                  CapsLock = "Esc";
                  Ctrl_L = "Esc";
                };
              }
            ];
            keymap = [
              {
                name = "Default (Nocturn, etc.)";
                application = {
                  not = ["Google-chrome" "Slack" "Gnome-terminal" "jetbrains-idea"];
                };
                remap = {
                  # Emacs basic
                  "C-b" = "left";
                  "C-f" = "right";
                };
              }
              {
                name = "Capslock to Esc";
                remap = {
                  "capslock" = "esc";
                };
              }
            ];
          };
        '';
      };
    };
  };

  imports = [
    inputs.xremap-flake.nixosModules.default
  ];

  config = let
    cfg = config.systemSettings;

    defaultRemaps = {
      keymap = [
        {
          name = "Capslock to Esc";
          remap = {
            "capslock" = "esc";
          };
        }
      ];
    };

    # Merge the lists in the default values with the custom ones
    mergeRemaps = r1: r2: lib.zipAttrsWith (name: values: lib.concatLists values) [r1 r2];
  in {
    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "intl";
    };

    # Configure remaps
    services.xremap = {
      enable = true;
      withGnome = true;
      mouse = true;
      config =
        if cfg.remaps != null
        then mergeRemaps defaultRemaps cfg.remaps
        else defaultRemaps;
    };

    # Configure console keymap
    console.keyMap = "us-acentos";
  };
}
