{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: {
  options = {
    userSettings.cli.sioyek = {
      stylix.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Apply custom Sioyek styles.";
      };
    };
  };

  config = let
    cfg = config.userSettings.cli.sioyek;
  in
    lib.mkIf (!config.userSettings.dotfiles.sioyek.enable) {
      programs.sioyek = {
        enable = true;

        # Force X11 on nvidia gpus
        package = lib.mkIf osConfig.systemSettings.nvidia.enable (pkgs.symlinkJoin {
          name = "sioyek-wrapped";
          paths = [pkgs.sioyek];
          buildInputs = [pkgs.makeWrapper];
          postBuild = ''
            wrapProgram $out/bin/sioyek \
              --set QT_QPA_PLATFORM xcb
          '';
        });

        config = {
          # Startup & Updates
          check_for_updates_on_startup = "0";
          use_legacy_keybinds = "0";
          should_load_tutorial_when_no_other_file = "1";
          startup_commands = "toggle_titlebar;toggle_custom_color";

          # Appearance
          background_color = "0.97 0.97 0.97";
          dark_mode_background_color = "0.0 0.0 0.0";
          dark_mode_contrast = "0.8";
          text_highlight_color = "1.0 1.0 0.0";
          visual_mark_color = "0.0 0.0 0.0 0.1";
          search_highlight_color = "0.0 1.0 0.0";
          link_highlight_color = "0.0 0.0 1.0";
          synctex_highlight_color = "0.05 0.05 0.05";

          # Colorscheme
          custom_background_color =
            if (!cfg.stylix.enable)
            then "#1D2021"
            else lib.mkForce config.lib.stylix.colors.withHashtag.base00;
          custom_text_color = lib.mkIf (!cfg.stylix.enable) "#ebdbb2";
          status_bar_color = lib.mkIf (!cfg.stylix.enable) "#32302f";
          page_separator_color = lib.mkIf (!cfg.stylix.enable) "#3c3836";

          # Search
          search_url_s = "https://scholar.google.com/scholar?q=";
          search_url_l = "http://gen.lib.rus.ec/scimag/?q=";
          search_url_g = "https://www.google.com/search?q=";
          middle_click_search_engine = "s";
          shift_middle_click_search_engine = "l";

          # Zoom and Navigation
          zoom_inc_factor = "1.2";
          vertical_move_amount = "1.0";
          horizontal_move_amount = "0.0";
          move_screen_ratio = "0.5";
          wheel_zoom_on_cursor = "0";
          page_separator_width = "2";
          fit_to_page_width_ratio = "0.75";

          # UI Elements
          flat_toc = "0";
          collapsed_toc = "0";
          should_use_multiple_monitors = "0";
          should_launch_new_instance = "0";
          should_launch_new_window = "0";
          should_draw_unrendered_pages = "0";
          rerender_overview = "1";
          default_dark_mode = "0";
          sort_bookmarks_by_location = "1";
          multiline_menus = "1";
          show_doc_path = "0";

          # Rulers and Visual Marks
          visual_mark_next_page_fraction = "0.75";
          visual_mark_next_page_threshold = "0.25";
          ruler_mode = "1";
          ruler_padding = "1.0";
          ruler_x_padding = "5.0";

          # Behavior
          create_table_of_contents_if_not_exists = "1";
          max_created_toc_size = "5000";
          should_warn_about_user_key_override = "1";
          single_click_selects_words = "0";
          prerender_next_page_presentation = "1";

          # Custom Highlight Colors
          highlight_color_a = "0.94 0.64 1.00";
          highlight_color_b = "0.00 0.46 0.86";
          highlight_color_c = "0.60 0.25 0.00";
          highlight_color_d = "0.30 0.00 0.36";
          highlight_color_e = "0.10 0.10 0.10";
          highlight_color_f = "0.00 0.36 0.19";
          highlight_color_g = "0.17 0.81 0.28";
          highlight_color_h = "1.00 0.80 0.60";
          highlight_color_i = "0.50 0.50 0.50";
          highlight_color_j = "0.58 1.00 0.71";
          highlight_color_k = "0.56 0.49 0.00";
          highlight_color_l = "0.62 0.80 0.00";
          highlight_color_m = "0.76 0.00 0.53";
          highlight_color_n = "0.00 0.20 0.50";
          highlight_color_o = "1.00 0.64 0.02";
          highlight_color_p = "1.00 0.66 0.73";
          highlight_color_q = "0.26 0.40 0.00";
          highlight_color_r = "1.00 0.00 0.06";
          highlight_color_s = "0.37 0.95 0.95";
          highlight_color_t = "0.00 0.60 0.56";
          highlight_color_u = "0.88 1.00 0.40";
          highlight_color_v = "0.45 0.04 1.00";
          highlight_color_w = "0.60 0.00 0.00";
          highlight_color_x = "1.00 1.00 0.50";
          highlight_color_y = "1.00 1.00 0.00";
          highlight_color_z = "1.00 0.31 0.02";
        };
      };
    };
}
