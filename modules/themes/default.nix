{lib, ...}:
with lib; let
  themesDir = ./.;

  # Find the nearest parent with default.nix and convert a path into a Theme Name
  # Example: ./gnome/dark/default.nix -> "gnome-dark"
  # Example: ./gnome/dark/test/test.nix -> "gnome-dark"
  pathToThemeName = filePath: let
    rootStr = toString themesDir;

    findThemeRoot = currentPath:
      if toString currentPath == rootStr
      then
        # Reached the root
        currentPath
      else if builtins.pathExists (currentPath + "/default.nix")
      then
        # Found the main theme config directory
        currentPath
      else
        # Recurse up to the parent directory
        findThemeRoot (dirOf currentPath);

    # Get the directory of the current file to start searching
    themeDir = findThemeRoot (dirOf filePath);

    # Calculate name relative to the themes root
    relativePath = removePrefix (rootStr + "/") (toString themeDir);
  in
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

  # A home module is any file named "home.nix" or located in a "home" directory
  isHomeModule = filePath: let
    pathStr = toString filePath;
    rootDirStr = toString themesDir;

    relativePath = lib.strings.removePrefix rootDirStr pathStr;
  in
    baseNameOf filePath
    == "home.nix"
    || lib.strings.hasInfix "/home/" relativePath;

  systemModules = filter (filePath: !(isHomeModule filePath)) themeConfigs;
  homeModules = filter (filePath: isHomeModule filePath) themeConfigs;
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
