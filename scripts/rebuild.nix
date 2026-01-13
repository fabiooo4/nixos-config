{
  pkgs,
  nixosDirectory,
}:
pkgs.writeShellScriptBin "rebuild" ''
  # Exit on error
  set -e

  # cd to your config dir
  pushd ${nixosDirectory}

  # Edit your config
  $EDITOR ${nixosDirectory}

  # Early return if no changes were detected
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

  # Prompt for confirmation
  read -p "Proceed with rebuild? (Y/n): " confirm
  if [[ "$confirm" == "n" || "$confirm" == "N" ]]; then
      echo "Rebuild cancelled."
      popd
      exit 0
  fi

  ${pkgs.git}/bin/git add .

  # echo -e "NixOS Rebuilding..."
  # Rebuild, output simplified errors and progress, log tracebacks
  # sudo nixos-rebuild switch --flake ${nixosDirectory} &> >(tee nixos-switch.log) ||
  #   (echo -e "\n\nError summary:\n" && cat nixos-switch.log | grep --color error && exit 1)
  ${pkgs.nh}/bin/nh os switch ${nixosDirectory} -H $(hostname) || exit 1

  # echo -e "\n\nHome-Manager Rebuilding..."
  # echo -e "\n\n"
  # Rebuild home manager
  # home-manager switch --flake ${nixosDirectory} &> >(tee home-switch.log) ||
  # (echo -e "\n\nError summary:\n" && cat home-switch.log | grep --color "error\|Error" && exit 1)
  # ${pkgs.nh}/bin/nh home switch ${nixosDirectory} -c $(whoami) || exit 1

  # # Get current generation metadata
  # current=$(nixos-rebuild list-generations | grep True | head -c 65 | sed "s/ * /  /g")
  #
  # # Commit all changes witih the generation metadata
  # ${pkgs.git}/bin/git commit -am "$current"

  # Prompt to commit changes
  read -p "Commit changes to git? (y/N): " commit_confirm
  if [[ "$commit_confirm" == "y" || "$commit_confirm" == "Y" ]]; then
      ${pkgs.git}/bin/git commit -v
      echo "Changes committed."
  else
      echo "Changes not committed."
  fi

  # Back to where you were
  popd

  # Notify successful
  ${pkgs.libnotify}/bin/notify-send -e "NixOS Rebuilt successfully" --icon=software-update-available
''
