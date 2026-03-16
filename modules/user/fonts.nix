{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      monocraft
      nerd-fonts.space-mono
      nerd-fonts.caskaydia-cove
      custom-pkgs.bedstead
    ];
  };
}
