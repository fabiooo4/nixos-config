{
  config,
  lib,
  ...
}: {
  options = {
    systemSettings = {
      users = lib.mkOption {
        description = "List of users to create on the system";
        type = lib.types.listOf lib.types.str;
      };

      adminUsers = lib.mkOption {
        description = "List of users to make root";
        type = lib.types.listOf lib.types.str;
      };
    };
  };

  config = {
    # Define all system user accounts.
    users.users =
      builtins.listToAttrs
      (map (user: {
          name = user;
          value = {
            isNormalUser = true;
            # Add wheel (sudo) only for admin users
            extraGroups = ["networkmanager"] ++ lib.optionals (lib.any (adminUser: adminUser == user) config.systemSettings.adminUsers) ["wheel"];
          };
        })
        config.systemSettings.users);

    # Define all users home config
    home-manager.users =
      builtins.listToAttrs
      (map (user: {
          name = user;
          value = {
            home.username = user;
            home.homeDirectory = "/home/${user}";
          };
        })
        config.systemSettings.users);
  };
}
