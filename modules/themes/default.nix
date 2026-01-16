{lib, ...}:
with lib; let
  themesDir = ./.;

  # Convert a path into a Theme Name
  # Example: ./gnome/dark/default.nix -> "gnome-dark"
  pathToThemeName = filePath: let
    pathStr = toString filePath;
    rootStr = toString themesDir;

    relativePath = removePrefix (rootStr + "/") pathStr;
    cleanPath = removeSuffix "/default.nix" relativePath;
  in
    replaceStrings ["/"] ["-"] cleanPath;

  # Returns the list of all .nix files except this one
  themeConfigs =
    filter
    (filePath: filePath != ./default.nix)
    (filesystem.listFilesRecursive themesDir);

  # List of valid theme names for the enumerator
  themeNames = map pathToThemeName (filter (filePath: baseNameOf filePath == "default.nix") themeConfigs);

  systemModules = filter (filePath: baseNameOf filePath != "home.nix") themeConfigs;
  homeModules = filter (filePath: baseNameOf filePath == "home.nix") themeConfigs;
in {
  imports = systemModules;

  options = {
    theme.active = lib.mkOption {
      type = lib.types.enum themeNames;
      default = "gnome-default";
      description =
        "The currently active system theme. "
        + "Available themes: ${concatStringsSep ", " themeNames}";
    };
  };

  config = {
    home-manager.sharedModules = homeModules;
  };
}
