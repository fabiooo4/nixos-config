{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      anki
    ];
  };
}
