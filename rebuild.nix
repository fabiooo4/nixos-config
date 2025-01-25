{
  pkgs,
  nixosDirectory,
}:
pkgs.writeShellScriptBin "rebuild" ''
  # A rebuild script that commits on a successful build
  set -e

  # Edit your config
  $EDITOR ${nixosDirectory}

  # cd to your config dir
  pushd ${nixosDirectory}

  # Early return if no changes were detected (thanks @singiamtel!)
  if ${pkgs.git}/bin/git diff --quiet '*.nix' ; then
      echo "No changes detected, exiting."
      popd
      exit 0
  fi

  # Autoformat your nix files
  ${pkgs.alejandra}/bin/alejandra . &>/dev/null \
    || ( ${pkgs.alejandra}/bin/alejandra . ; echo "formatting failed!" && exit 1)

  # Shows your changes
  ${pkgs.git}/bin/git diff -U0 '*.nix'

  echo "NixOS Rebuilding..."

  # Rebuild, output simplified errors and progress, log tracebacks
  sudo nixos-rebuild switch --flake ${nixosDirectory} &> nixos-switch.log | (tail -f nixos-switch.log | grep "built\|copied\|MiB") || (cat nixos-switch.log | grep --color error && exit 1)

  # Get current generation metadata
  current=$(nixos-rebuild list-generations | grep current)

  # Commit all changes witih the generation metadata
  ${pkgs.git}/bin/git commit -am "$current"

  # Back to where you were
  popd

  # Notify successful
  ${pkgs.libnotify}/bin/notify-send -e "NixOS Rebuilt successfully" --icon=software-update-available
''
