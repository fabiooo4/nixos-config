{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      monocraft
      nerd-fonts.space-mono
    ];
  };
}
