{
  description = "Nixos config flake";

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

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Commit for keyboard shortcuts options
    zen-browser.url = "github:0xc000022070/zen-browser-flake/85ef44c";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs-unstable";
    zen-browser.inputs.home-manager.follows = "home-manager";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux"; # system arch

    userSettings = {
      username = "fabibo"; # username
      name = "Fabibo"; # name/identifier
      dotfilesDir = "/home/" + userSettings.username + "/.dotfiles"; # absolute path of the local repo
      nixosConfigDir = "/home/" + userSettings.username + "/.config/nixconfig"; # absolute path of the nix config
      font = "CaskaydiaCove Nerd Font"; # Selected font
      fontPkg = pkgs.nerd-fonts.caskaydia-cove; # Font package
      cursor = "XCursor-Pro-Dark"; # Selected cursor
      cursorPkg = pkgs.xcursor-pro; # Cursor package
      wallpaper = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/fabiooo4/wallpapers/main/wallhaven-5w6w89.png";
        hash = "sha256-Z+CICFZSN64oIhhe66X7RlNn/gGCYAn30NLNoEHRYJY=";
      };
      profilePicture = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/fabiooo4/wallpapers/main/pfp/nika.png";
        hash = "sha256-m6NYaEL9KZ3GHPbDLUS5Qad9Oh1n60uwukdWMWlq7/o=";
      };
      term = "kitty"; # Default terminal command
      editor = "nvim"; # Default editor
      browser = "zen-beta"; # Default browser
    };

    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {
          inherit inputs;
          inherit userSettings;
        };
        modules = [
          inputs.nix-flatpak.nixosModules.nix-flatpak
          inputs.xremap-flake.nixosModules.default
          inputs.stylix.nixosModules.stylix

          ./hosts/nixos/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      fabibo = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
          inherit userSettings;
        };
        modules = [
          inputs.stylix.homeModules.stylix
          ./hosts/nixos/home.nix
        ];
      };
    };
  };
}
