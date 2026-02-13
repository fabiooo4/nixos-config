{pkgs, ...}: {
  config = {
    programs.vesktop = {
      enable = true;
      package = pkgs.unstable.vesktop;
    };
  };
}
