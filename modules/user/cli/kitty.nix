{
  lib,
  config,
  pkgs,
  ...
}: {
  config = {
    programs.kitty = lib.mkIf (!config.userSettings.dotfiles.kitty.enable) {
      enable = true;

      # TODO: add colorscheme option, and stylix toggle
      # Let stylix handle the colorscheme
      # theme = "Gruvbox Dark Hard";

      # TODO: Add font option
      font = lib.mkForce {
        # Override stylix font
        name = "Monocraft";
        size = 15;
        package = pkgs.monocraft;
      };

      settings = {
        linux_display_server = "wayland";

        # --- Fonts ---
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";

        # --- Cursor ---
        cursor = "none";
        cursor_shape = "block";
        cursor_trail = 1;
        cursor_trail_start_threshold = 0;

        # --- Scrollback ---
        touch_scroll_multiplier = 8.0;

        # --- Mouse ---
        url_style = "straight";
        default_pointer_shape = "arrow";

        # --- Bell ---
        enable_audio_bell = "no";

        # --- Window Layout ---
        enabled_layouts = "splits:split_axis=horizontal, stack";
        window_border_width = "0.5pt";
        active_border_color = "#D65D0E";
        inactive_border_color = "#D65D0E";
        hide_window_decorations = "yes";

        # --- Tab Bar ---
        tab_bar_min_tabs = 2;
        tab_bar_edge = "top";
        tab_bar_style = "powerline";
        tab_powerline_style = "angled";
        # Note: Nix strings require escaping, but simple interpolation usually passes fine
        # unless it conflicts with Nix syntax.
        tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";

        # --- Advanced ---
        editor = "nvim";
        notify_on_cmd_finish = "invisible 20 notify";
        allow_remote_control = "yes";
        listen_on = "unix:/tmp/mykitty";

        # --- Shortcuts Settings ---
        kitty_mod = "shift+alt";
      };

      keybindings = {
        # --- Clipboard ---
        "ctrl+shift+c" = "copy_to_clipboard";
        "ctrl+shift+v" = "paste_from_clipboard";

        # --- Window Management ---
        "kitty_mod+enter" = "launch --cwd=current --location=hsplit";
        "kitty_mod+\\" = "launch --cwd=current --location=vsplit";

        # --- Vim Motions / Smart Splits ---
        # Ensure pass_keys.py is present in your config directory (see note below)
        "shift+alt+j" = "kitten pass_keys.py bottom shift+alt+j nvim";
        "shift+alt+k" = "kitten pass_keys.py top    shift+alt+k nvim";
        "shift+alt+h" = "kitten pass_keys.py left   shift+alt+h nvim";
        "shift+alt+l" = "kitten pass_keys.py right  shift+alt+l nvim";

        # --- Resize Window ---
        "shift+ctrl+h" = "resize_window narrower";
        "shift+ctrl+l" = "resize_window wider";
        "shift+ctrl+k" = "resize_window taller";
        "shift+ctrl+j" = "resize_window shorter";
        "ctrl+shift+home" = "resize_window reset";

        # --- Move Active Window ---
        "kitty_mod+ctrl+k" = "move_window up";
        "kitty_mod+ctrl+h" = "move_window left";
        "kitty_mod+ctrl+l" = "move_window right";
        "kitty_mod+ctrl+j" = "move_window down";

        # --- Layouts ---
        "alt+z" = "toggle_layout stack";

        # --- Tab Management ---
        "kitty_mod+." = "next_tab";
        "kitty_mod+," = "previous_tab";
        "kitty_mod+t" = "new_tab";
        "kitty_mod+]" = "move_tab_forward";
        "kitty_mod+[" = "move_tab_backward";
        "shift+ctrl+t" = "set_tab_title";
        "kitty_mod+right" = "next_tab";
        "kitty_mod+left" = "previous_tab";

        # --- Font Sizes ---
        "kitty_mod+equal" = "change_font_size current +1.0";
        "kitty_mod+minus" = "change_font_size current -1.0";
        "kitty_mod+0" = "change_font_size current 0";
        "kitty_mod+9" = "change_font_size current -16";
      };
    };

    systemd.user.sessionVariables = {
      TERMINAL = "kitty";

      # TODO: termporary fix to glfw error on wayland
      # KITTY_DISABLE_WAYLAND = 1;
    };

    # Change kitty image
    xdg.desktopEntries.kitty = {
      icon = "${config.userSettings.dotfiles.dotfilesDir}/.config/kitty/kitty.app.png";
      name = "Kitty";
      exec = "kitty";
      comment = "Fast, feature-rich, GPU based terminal";
      categories = ["System" "TerminalEmulator"];
    };

    # Fetch utility scripts
    xdg.configFile."kitty/pass_keys.py".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/knubie/vim-kitty-navigator/master/pass_keys.py";
      hash = "sha256-sNd1Vmg2prioRTtUx+72zfVjRnhM3cdZ9xpmrj5T6LM=";
    };

    xdg.configFile."kitty/get_layout.py".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/knubie/vim-kitty-navigator/master/get_layout.py";
      hash = "sha256-HjcFRcQ3WnBsgctb3w4Mytfld2vTOMyGmfZhyZ4RrQQ=";
    };
  };
}
