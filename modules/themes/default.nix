{lib, ...}:
with lib; let
  themesDir = ./.;

  # Convert a path into a Theme Name
  # Example: ./gnome/dark/default.nix -> "gnome-dark"
  pathToThemeName = filePath: let
    # Get the directory containing the file (e.g. .../gnome/default)
    directory = dirOf filePath;
    pathStr = toString directory;
    rootStr = toString themesDir;

    # Get path relative to themes root (e.g. gnome/default)
    relativePath = removePrefix (rootStr + "/") pathStr;
  in
    # Replace slashes with dashes (e.g. gnome-default)
    replaceStrings ["/"] ["-"] relativePath;

  # Returns the list of all .nix files except this one
  themeConfigs =
    filter
    (filePath: filePath != ./default.nix)
    (filesystem.listFilesRecursive themesDir);

  # List of valid theme names for the enumerator
  themeNames = map pathToThemeName (filter (filePath: baseNameOf filePath == "default.nix") themeConfigs);

  # Pass the theme name to each imported module
  importWithThemeName = filePath: {
    config,
    lib,
    pkgs,
    ...
  } @ args: let
    themeName = pathToThemeName filePath;
    moduleFn = import filePath;
  in
    # Merge the theme name into the module arguments
    moduleFn ({inherit config lib pkgs;} // args // {inherit themeName;});

  systemModules = filter (filePath: baseNameOf filePath != "home.nix") themeConfigs;
  homeModules = filter (filePath: baseNameOf filePath == "home.nix") themeConfigs;
in {
  imports = map importWithThemeName systemModules;

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
    home-manager.sharedModules = map importWithThemeName homeModules;
  };
}
