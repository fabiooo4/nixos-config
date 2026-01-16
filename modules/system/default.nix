{lib, ...}: let
  # Returns the list of all non hidden nix files
  importModulesFrom = dir:
    lib.filter (filePath: filePath != dir + "/default.nix" && !lib.hasPrefix "." (baseNameOf filePath))
    (lib.filesystem.listFilesRecursive dir);
in {
  imports = importModulesFrom ./.;
}
