final: prev: let
  lib = final.lib;
  packagesDir = ./packages;

  dirContents = builtins.readDir packagesDir;

  nixFiles =
    lib.filterAttrs
    (name: type: type == "regular" && lib.hasSuffix ".nix" name)
    dirContents;

  generatedPkgs =
    lib.mapAttrs' (
      name: _: let
        pkgName = lib.removeSuffix ".nix" name;
      in
        lib.nameValuePair pkgName (final.callPackage (packagesDir + "/${name}") {})
    )
    nixFiles;
in {
  custom-pkgs = generatedPkgs;
}
