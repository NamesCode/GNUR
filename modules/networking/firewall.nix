{
  config,
  lib,
  pkgs,
}: {
  builder = builtins.writeShellScript "builder.sh" ''
    echo "hi, my name is ''${0}" # escape bash variable
    echo "hi, my hash is ${pkgs}" # use nix variable
    echo "hello world" >output.txt
  '';
}
