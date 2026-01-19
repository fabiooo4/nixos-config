{
  description = "Nixos config flake";

  outputs = {nixpkgs, ...} @ inputs: let
    lib = nixpkgs.lib;
    system = "x86_64-linux";

    # Gets the list of hostnames from the names of all the directories inside the input path
    getHosts = hosts_path:
      builtins.filter (host: host != null)
      (lib.mapAttrsToList (name: value:
        if value == "directory"
        then name
        else null) (builtins.readDir hosts_path));

    /*
       pkgs = import inputs.nixpkgs-unstable {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
    */
    # Adds unstable overlay to pkgs
    # To access unstable packages use: pkgs.unstable.packageName
    overlay-unstable = final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    };
  in {
    # For each host create a nixosSystem importing the default.nix file in that host directory
    nixosConfigurations =
      builtins.listToAttrs
      (map (host: {
          name = host;
          value = nixpkgs.lib.nixosSystem {
            system = system;
            specialArgs = {
              inherit inputs;
            };
            modules = [
              ({...}: {nixpkgs.overlays = [overlay-unstable];})
              {config.networking.hostName = host;}

              (./hosts + "/${host}")

              ./modules/system
              ./modules/themes

              inputs.home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = {
                  inherit inputs;
                };
              }
            ];
          };
        })
        (getHosts ./hosts));
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap-flake.url = "github:xremap/nix-flake";
    xremap-flake.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix/release-25.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Commit for keyboard shortcuts options
    zen-browser.url = "github:0xc000022070/zen-browser-flake/85ef44c";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs-unstable";
    zen-browser.inputs.home-manager.follows = "home-manager";
  };
}
