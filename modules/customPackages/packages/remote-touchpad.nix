{
  writeShellScriptBin,
  remote-touchpad,
}: let
  remote-touchpad-patched = remote-touchpad.overrideAttrs (old: {
    tags = ["portal" "uinput" "x11"];
  });
in (writeShellScriptBin "remote-touchpad" ''
  exec ${remote-touchpad-patched}/bin/remote-touchpad -bind=0.0.0.0:43877 -update-rate 60 "$@"
'')
