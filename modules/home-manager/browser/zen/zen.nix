{
  inputs,
  userSettings,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = let
    containers = {
      Utils = {
        color = "orange";
        icon = "fingerprint";
        id = 3;
      };
    };

    spaces = {
      "Nix" = {
        id = "2441acc9-79b1-4afb-b582-ee88ce554ec0";
        icon = "❄️";
        position = 3000;
        theme = {
          type = "gradient";
          colors = [
            {
              red = 150;
              green = 190;
              blue = 230;
              algorithm = "floating";
              type = "explicit-lightness";
            }
          ];
          opacity = 0.2;
          texture = 0.5;
        };
      };
    };

    pins = {
      "GitHub" = {
        id = "9d8a8f91-7e29-4688-ae2e-da4e49d4a179";
        container = containers.Utils.id;
        url = "https://github.com/";
        isEssential = true;
        position = 101;
      };

      "WhatsApp" = {
        id = "8af62707-0722-4049-9801-bedced343333";
        container = containers.Utils.id;
        url = "https://web.whatsapp.com/";
        isEssential = true;
        position = 102;
      };

      "Nix" = {
        id = "d85a9026-1458-4db6-b115-346746bcc692";
        workspace = spaces.Nix.id;
        isGroup = true;
        isFolderCollapsed = false;
        editedTitle = true;
        position = 200;
      };
      "Nix Packages" = {
        id = "f8dd784e-11d7-430a-8f57-7b05ecdb4c77";
        workspace = spaces.Nix.id;
        folderParentId = pins."Nix".id;
        url = "https://search.nixos.org/packages";
        position = 201;
      };
      "Nix Options" = {
        id = "92931d60-fd40-4707-9512-a57b1a6a3919";
        workspace = spaces.Nix.id;
        folderParentId = pins."Nix".id;
        url = "https://search.nixos.org/options";
        position = 202;
      };
      "Home Manager Options" = {
        id = "2eed5614-3896-41a1-9d0a-a3283985359b";
        workspace = spaces.Nix.id;
        folderParentId = pins."Nix".id;
        url = "https://home-manager-options.extranix.com";
        position = 203;
      };
    };
  in {
    enable = true;
    profiles = {
      ${userSettings.username} = {
        keyboard-shortcuts = {
          source = ./zen-keyboard-shortcuts.json;
        };

        pinsForce = true;
        containersForce = true;
        inherit containers spaces pins;
      };
    };
  };

  stylix.targets.zen-browser.profileNames = [userSettings.username];
}
