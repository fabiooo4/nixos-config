{pkgs, ...}: {
  config = {
    # Enable fonts from pkgs list
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      monocraft
      nerd-fonts.symbols-only
      nerd-fonts.space-mono
      nerd-fonts.caskaydia-cove
      custom-pkgs.bedstead
      custom-pkgs.determinationMono
      custom-pkgs.scientifica
    ];
  };
}
