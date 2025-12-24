{
  inputs,
  userSettings,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = {
    enable = true;
    profiles = {
      ${userSettings.username} = {
        keyboard-shortcuts = {
          source = ./zen-keyboard-shortcuts.json;
        };
      };
    };
  };

  stylix.targets.zen-browser.profileNames = [userSettings.username];
}
