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

    extraWrapperArgs = [
      "--prefix"
      "LD_LIBRARY_PATH"
      ":"
      "${pkgs.lib.makeLibraryPath [pkgs.icu]}"
    ];

    extraLuaPackages = ps: [ps.magick];

    extraPackages = with pkgs; [
      # LSP
      clang-tools
      lua-language-server
      vscode-langservers-extracted
      marksman
      glsl_analyzer
      svelte-language-server
      tailwindcss-language-server
      typescript-language-server
      (python3.withPackages (
        ps:
          with ps; [
            jedi-language-server
          ]
      ))
      matlab-language-server
      nil

      # Neovim plugin dependencies
      imagemagick
      gcc
      tree-sitter
      lua51Packages.lua
      luajitPackages.luarocks
      stylua
      nixd
      nil
      alejandra
      nodePackages.prettier
      black
      ripgrep
      gcc
      nodejs
      yarn
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
