{...}: {
  config = {
    programs.noctalia-shell.settings.templates.activeTemplates = [
      {
        id = "zenBrowser";
        active = true;
      }
    ];

    programs.zen-browser.profiles.default.settings = {
      toolkit.legacyUserProfileCustomizations.stylesheets = true;
    };
  };
}
