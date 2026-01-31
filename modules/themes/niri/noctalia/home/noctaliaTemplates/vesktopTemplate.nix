{...}: {
  config = {
    programs.noctalia-shell.settings.templates.activeTemplates = [
      {
        id = "discord";
        active = true;
      }
    ];

    programs.vesktop.vencord = {
      settings = {
        enabledThemes = ["noctalia.theme.css"];
      };
    };
  };
}
