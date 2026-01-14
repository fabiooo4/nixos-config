{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options = {
    systemSettings = {
      nvidia.enable = lib.mkEnableOption "nvidia drivers";

      flatpak = {
        enable = lib.mkEnableOption "flatpaks";
        autoUpdate.enable = lib.mkOption {
          description = "Whether to enable flatpak autoupdates";
          type = lib.types.bool;
          default = true;
        };
      };
    };
  };

  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  config = let
    cfg = config.systemSettings;
    nixosConfigDir = "/home/fabibo/.config/nixconfig"; # TODO: Change to a system wide directory
  in {
    systemSettings.drawingTablet.enable = true;

    system.stateVersion = "24.11"; # Don't change

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Activate flakes
    nix = {
      settings.experimental-features = ["nix-command" "flakes"];
      nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    };

    # Change default shell to zsh
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    # GPU Drivers
    hardware = {
      # Enable opengl
      graphics = {
        enable = true;
        enable32Bit = true; # Needed for some 32-bit apps/games
      };

      nvidia = lib.mkIf cfg.nvidia.enable {
        modesetting.enable = true;

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
        # of just the bare essentials.
        powerManagement.enable = true;

        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        powerManagement.finegrained = false;

        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        # Support is limited to the Turing and later architectures. Full list of
        # supported GPUs is at:
        # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
        # Only available from driver 515.43.04+
        open = true;

        # Enable the Nvidia settings menu,
        # accessible via `nvidia-settings`.
        nvidiaSettings = true;

        # Optionally, you may need to select the appropriate driver version for your specific GPU.
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };
    };

    services = {
      # Enable the X11 windowing system with nvidia drivers
      xserver = {
        enable = true;
        videoDrivers = lib.mkIf cfg.nvidia.enable ["nvidia"];
      };
    };

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Internationalisation properties.
    time.timeZone = "Europe/Rome";
    i18n = {
      defaultLocale = "en_US.UTF-8";

      extraLocaleSettings = {
        LC_ADDRESS = "it_IT.UTF-8";
        LC_IDENTIFICATION = "it_IT.UTF-8";
        LC_MEASUREMENT = "it_IT.UTF-8";
        LC_MONETARY = "it_IT.UTF-8";
        LC_NAME = "it_IT.UTF-8";
        LC_NUMERIC = "it_IT.UTF-8";
        LC_PAPER = "it_IT.UTF-8";
        LC_TELEPHONE = "it_IT.UTF-8";
        LC_TIME = "it_IT.UTF-8";
      };
    };

    # Remove default programs
    documentation.nixos.enable = false;
    documentation.man.enable = true;
    services.xserver.excludePackages = [pkgs.xterm];

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Custom rebuild script
    environment.systemPackages = let
      rebuild-script = import ../../scripts/rebuild.nix {
        inherit pkgs;
        nixosDirectory = nixosConfigDir;
      };
    in [
      rebuild-script
    ];

    environment.variables = {
      FLAKE = nixosConfigDir;
      NH_FLAKE = nixosConfigDir;
    };

    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = [
      # Add any missing dynamic libraries for unpackaged programs
      # here, NOT in environment.systemPackages
    ];

    # Flatpaks
    services.flatpak = lib.mkIf cfg.flatpak.enable {
      enable = true;
      update.auto = lib.mkIf cfg.flatpak.autoUpdate.enable {
        enable = true;
        onCalendar = "weekly";
      };
    };

    # Enable automatic login for the user.
    # services.xserver.displayManager.autoLogin.enable = true;
    # services.xserver.displayManager.autoLogin.user = "fabio";

    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    # systemd.services."getty@tty1".enable = false;
    # systemd.services."autovt@tty1".enable = false;
  };
}
