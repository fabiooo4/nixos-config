{
  pkgs,
  fetchurl,
  nerd-font-patcher,
}:
pkgs.stdenvNoCC.mkDerivation {
  pname = "Bedstead Nerd Font";
  version = "3.261";

  src = fetchurl {
    url = "https://bjh21.me.uk/bedstead/bedstead.otf";
    hash = "sha256-lHPFZxxwPSbnKKgYf40wynoZSX7hfMWwdr0PtuKYYAc=";
  };

  dontUnpack = true;

  nativeBuildInputs = [nerd-font-patcher];

  buildPhase = ''
    mkdir -p $out/share/fonts/opentype
    nerd-font-patcher -c $src -out $out/share/fonts/opentype/
  '';

  installPhase = "true";
}
