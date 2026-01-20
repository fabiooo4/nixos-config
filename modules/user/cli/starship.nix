{
  lib,
  config,
  ...
}: {
  options = {
    userSettings.cli.starship = {
      colorscheme = lib.mkOption {
        type = lib.types.enum ["base16" "gruvbox_dark"];
        default = "base16";
        description = "The colorscheme to use for the starship prompt.";
      };
    };
  };

  config = let
    cfg = config.userSettings.cli.starship;
  in {
    programs.starship = lib.mkIf (!config.userSettings.dotfiles.kitty.enable) {
      enable = true;

      settings = {
        palette = cfg.colorscheme;

        palettes.base16 = let
          colors = config.lib.stylix.colors;
        in
          if config.stylix.enable && cfg.colorscheme == "base16"
          then {
            color_fg0 = "#${colors.base05}";
            color_bg1 = "#${colors.base01}";
            color_bg3 = "#${colors.base02}";
            color_blue = "#${colors.base0D}";
            color_aqua = "#${colors.base0C}";
            color_green = "#${colors.base0B}";
            color_orange = "#${colors.base09}";
            color_purple = "#${colors.base0E}";
            color_red = "#${colors.base08}";
            color_yellow = "#${colors.base0A}";
          }
          else {
            color_fg0 = "#fbf1c7";
            color_bg1 = "#3c3836";
            color_bg3 = "#665c54";
            color_blue = "#458588";
            color_aqua = "#689d6a";
            color_green = "#98971a";
            color_orange = "#d65d0e";
            color_purple = "#b16286";
            color_red = "#cc241d";
            color_yellow = "#d79921";
          };

        format = builtins.concatStringsSep "" [
          "[\\\[](color_red bold)"
          "$username"
          "[@](color_yellow bold)"
          "$hostname"
          "$directory"
          "[\\\]](color_purple bold)"
          "$git_branch"
          "$git_status"
          "$shlvl"
          "$character"
        ];

        character = {
          success_symbol = "[\\$](color_fg0)";
          error_symbol = "[\\$](color_red)";
          vimcmd_symbol = "[\\$](color_green)";
        };

        directory = {
          truncation_length = 4;
          style = "color_blue bold";
          truncation_symbol = "…/";
          format = "[ $path]($style)";
        };

        username = {
          show_always = true;
          style_user = "color_orange bold";
          style_root = "color_orange bold";
          format = "[$user]($style)";
          disabled = false;
        };

        hostname = {
          ssh_only = false;
          style = "color_green bold";
          format = "[$hostname]($style)";
          disabled = false;
        };

        git_branch = {
          style = "color_aqua bold";
          format = "[ $symbol$branch ]($style)";
        };

        git_status = {
          style = "color_orange bold";
          conflicted = "✖";
          ahead = "⇡";
          behind = "⇣";
          diverged = "⇕";
          untracked = "…";
        };

        shlvl = {
          disabled = false;
          style = "color_blue";
          symbol = "";
          format = "[$symbol $shlvl ]($style)";
        };
      };
    };
  };
}
