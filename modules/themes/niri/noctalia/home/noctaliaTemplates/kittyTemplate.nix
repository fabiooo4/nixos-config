{...}: {
  config = {
    programs.noctalia-shell.settings.templates.activeTemplates = [
      {
        id = "kitty";
        active = true;
      }
    ];

    programs.kitty.extraConfig = ''
      include themes/noctalia.conf
    '';
  };
}
