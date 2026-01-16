{
  pkgs,
  nixosDirectory,
}:
pkgs.writeShellScriptBin "rebuild" ''
  # Exit on error
  set -e

  # Get parameters
  auto_confirm=false
  auto_commit=false
  auto_push=false
  rebuild_now=false
  commit_message=""

  while getopts 'yc:pn' flag; do
    case "''${flag}" in
      y) auto_confirm=true ;;
      c)
       auto_commit=true
       commit_message="''${OPTARG}"
       ;;
      p) auto_push=true ;;
      n) rebuild_now=true ;;
      *) echo "Usage: rebuild [-y] [-c <message>] [-p] [-n]"
         echo "-y : Auto confirm rebuild"
         echo "-c : Auto commit changes with the provided message"
         echo "-p : Auto push committed changes to remote"
         echo "-n : Rebuild now, skipping editor and confirmation"
         exit 1 ;;
    esac
  done


  # cd to your config dir
  pushd ${nixosDirectory} > /dev/null

  if [ "$rebuild_now" = false ]; then
      # Edit your config
      $EDITOR ${nixosDirectory}

      # Early return if no changes were detected
      if ${pkgs.git}/bin/git diff --quiet '*.nix' ; then
          echo "No changes detected, exiting."
          popd > /dev/null
          exit 0
      fi

      # Autoformat your nix files
      ${pkgs.alejandra}/bin/alejandra . &>/dev/null \
        || ( ${pkgs.alejandra}/bin/alejandra . ; echo "formatting failed!" && exit 1)

      # Shows your changes
      ${pkgs.git}/bin/git diff -U0 '*.nix'

      # Prompt for confirmation
    # Prompt for confirmation
      if [ "$auto_confirm" == true ]; then
          echo "Auto-confirm enabled, proceeding with rebuild."
      else
          read -p "Proceed with rebuild? (Y/n): " confirm
          if [[ "$confirm" == "n" || "$confirm" == "N" ]]; then
            echo "Rebuild cancelled."
            popd > /dev/null
            exit 0
          fi
      fi
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

  # Notify successful
  ${pkgs.libnotify}/bin/notify-send -e "NixOS Rebuilt successfully" --icon=software-update-available

  # Prompt to commit changes
  if [ "$auto_commit" == true ]; then
      echo "Auto-commit enabled, proceeding to commit changes with message:"

    if [[ -n "$commit_message" ]]; then
        echo "$commit_message"
        ${pkgs.git}/bin/git commit -am "$commit_message"
    else
        # Get current generation metadata
        commit_message=$(${pkgs.nixos-rebuild}/bin/nixos-rebuild list-generations | grep True | head -c 65 | sed "s/ * /  /g")

        echo "$commit_message"
        ${pkgs.git}/bin/git commit -am "$commit_message"
    fi
  else
      read -p "Commit changes to git? (y/N): " commit_confirm

      if [[ "$commit_confirm" == "y" || "$commit_confirm" == "Y" ]]; then
          ${pkgs.git}/bin/git commit -v
          echo "Changes committed."
      else
          echo "Changes not committed."
      fi
  fi


  # If did not commit don't prompt to push
  if [[ "$commit_confirm" != "y" && "$commit_confirm" != "Y" && "$auto_commit" != true ]]; then
      echo "No commit made, skipping push."
      popd > /dev/null
      exit 0
  fi

  # Prompt to push changes
  if [ "$auto_push" == true ]; then
      echo "Auto-push enabled, proceeding to push changes."
  else
      read -p "Push committed changes to remote? (y/N): " push_confirm
  fi

  if [[ "$push_confirm" == "y" || "$push_confirm" == "Y" || "$auto_push" == true ]]; then
      ${pkgs.git}/bin/git push
      echo "Changes pushed to remote."
  else
      echo "Changes not pushed."
  fi

  # Back to where you were
  popd > /dev/null
''
