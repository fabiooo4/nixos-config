{
  config,
  pkgs,
  ...
}: {
  # Nvim
  home.file = {
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.userSettings.dotfiles.dotfilesDir}/.config/nvim";
    };
  };

  systemd.user.sessionVariables = {
    EDITOR = "nvim";
  };

  xdg.desktopEntries.nvim = {
    name = "Neovim";
    comment = "Edit text files in Kitty";
    icon = "nvim";
    exec = "kitty nvim %F";
    categories = ["Utility" "TextEditor"];
    mimeType = ["text/plain" "text/markdown"];
    terminal = false;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraLuaPackages = ps: [ps.magick];
    extraPackages = with pkgs; [
      imagemagick

      # Neovim plugin dependencies
      lua51Packages.lua
      luajitPackages.luarocks
      stylua
      nixd
      nil
      alejandra
      nodePackages.prettier
      ripgrep
      gcc
      nodejs
      xclip
      fd
      unzip
      wget
      tree-sitter
      texliveFull
      gnumake
      rustup
      python3
      # --------------
    ];
  };
}
