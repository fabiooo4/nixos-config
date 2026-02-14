{
  pkgs,
  nixosDirectory,
}:
pkgs.writeShellScriptBin "benchmark" ''
  pushd ${nixosDirectory} > /dev/null

  nix eval --no-eval-cache .\#nixosConfigurations.$(hostname).config.system.build.toplevel \
    --option eval-profiler flamegraph \
    --option eval-profile-file /tmp/$(hostname)_profile

  ${pkgs.flamegraph}/bin/flamegraph.pl /tmp/$(hostname)_profile > /tmp/$(hostname)_profile.svg

  xdg-open /tmp/$(hostname)_profile.svg

  rm /tmp/$(hostname)_profile

  popd > /dev/null
''
