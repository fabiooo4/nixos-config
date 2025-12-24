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
      ${userSettings.username} = {};
    };
  };

  stylix.targets.zen-browser.profileNames = [userSettings.username];
}
