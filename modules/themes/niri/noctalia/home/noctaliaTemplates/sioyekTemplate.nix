{
  pkgs,
  lib,
  config,
  osConfig,
  themeName,
  ...
}: {
  config = let
    enabled = osConfig.theme.active == themeName;

    templatePath = pkgs.writeText "sioyekTemplate.config" ''
      background_color {{colors.surface.light.hex}}
      dark_mode_background_color {{colors.surface.dark.hex}}
      dark_mode_contrast 0.8
      text_highlight_color 1.0 1.0 0.0
      visual_mark_color 0.0 0.0 0.0 0.1
      search_highlight_color 0.0 1.0 0.0
      link_highlight_color 0.0 0.0 1.0
      synctex_highlight_color 0.05 0.05 0.05

      custom_background_color {{colors.surface.default.hex}}
      custom_text_color {{colors.on_surface.default.hex}}
      status_bar_color {{colors.primary.default.hex}}
      status_bar_text_color {{colors.on_primary.default.hex}}
      page_separator_color {{colors.secondary.default.hex}}
    '';

    outputPath = "${config.xdg.configHome}/sioyek/colorscheme.config";
  in
    lib.mkIf enabled
    {
      programs.sioyek.config = {
        background_color = lib.mkForce "";
        dark_mode_background_color = lib.mkForce "";
        custom_background_color = lib.mkForce "";
        custom_text_color = lib.mkForce "";
        status_bar_color = lib.mkForce "";
        page_separator_color = lib.mkForce "";

        source = outputPath;
      };

      theme.${themeName}.templates.sioyek = {
        inputPath = templatePath;
        outputPath = outputPath;
      };
    };
}
