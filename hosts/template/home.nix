{
  pkgs,
  inputs,
  ...
}: {
  config = {
    userSettings = {
    };

    home.packages = with pkgs; [
    ];
  };
}
