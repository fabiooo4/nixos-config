{
  pkgs,
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
      "Main" = {
        id = "2441acc9-79b1-4afb-b582-ee88ce554ec1";
        container = containers.Utils.id;
        icon = "🏵️";
        position = 2000;
        theme = {
          type = "gradient";
          colors = [
            {
              red = 190;
              green = 160;
              blue = 130;
              algorithm = "floating";
              type = "explicit-lightness";
            }
          ];
          opacity = 0.2;
          texture = 0.5;
        };
      };
      "Nix" = {
        id = "2441acc9-79b1-4afb-b582-ee88ce554ec0";
        container = containers.Utils.id;
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

        settings = {
          zen.view.compact = {
            hide-toolbar = true;
          };
        };

        search = {
          force = true;
          default = "google";
          engines = let
            nixSnowflakeIcon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          in {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = nixSnowflakeIcon;
              definedAliases = ["np"];
            };
            "Nix Options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = nixSnowflakeIcon;
              definedAliases = ["nop"];
            };
            "Home Manager Options" = {
              urls = [
                {
                  template = "https://home-manager-options.extranix.com/";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                    {
                      name = "release";
                      value = "master"; # unstable
                    }
                  ];
                }
              ];
              icon = nixSnowflakeIcon;
              definedAliases = ["hmop"];
            };
            bing.metaData.hidden = "true";
          };
        };
      };
    };
  };

  stylix.targets.zen-browser.profileNames = [userSettings.username];
}
