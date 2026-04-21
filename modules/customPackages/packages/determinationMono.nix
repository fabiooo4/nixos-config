{
  pkgs,
  fetchgit,
  nerd-font-patcher,
}:
pkgs.stdenvNoCC.mkDerivation {
  pname = "DeterminationMonoWeb Nerd Font Mono";
  version = "master";

  src = fetchgit {
    url = "https://gitlab.com/cartr/undertale-fonts.git";
    rev = "master";
    sparseCheckout = [
      "ttf/DeterminationMonoWeb.ttf"
    ];
    hash = "sha256-C67aie5kOuX3DHdUMF3GC5/tNImETJKlKLKl251rXc4=";
  };

  dontUnpack = true;

  nativeBuildInputs = [nerd-font-patcher];

  buildPhase = ''
    runHook preBuild

    mkdir -p patched_fonts
    nerd-font-patcher $src/ttf/DeterminationMonoWeb.ttf --mono -out patched_fonts

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype/
    install -Dm444 patched_fonts/*.ttf $out/share/fonts/truetype/

    runHook postInstall
  '';
}
