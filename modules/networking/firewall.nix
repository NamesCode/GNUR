{
  lib,
  config,
  ...
}:
with lib; let
  # Shorter name to access final settings a
  # user of hello.nix module HAS ACTUALLY SET.
  # cfg is a typical convention.
  cfg = config.services.firewall;
in {
  # Declare what settings a user of this "hello.nix" module CAN SET.
  options.services.firewall = {
    enable = mkEnableOption "pfctl firewall interface for macOS";
    configFile = mkOption {
      type = types.str;
      default = "";
    };
    logging = mkOption {
      enable = mkEnableOption "logging for the firewall";
      logFile = mkOption {
        type = types.str;
        default = "";
      };
      loggingLevel = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          Logging options for pfctl. It takes in the same commands of pfctl, these being: [emerg, alert, crit, err, warning, notice, info, debug]. See `man pfctl`.
        '';
      };
    };
  };

  pfctlConfig =
    if configFile != ""
    then ''${configFile}''
    else ''echo $(cat /etc/pf.conf)'';

  # Define what other settings, services and resources should be active IF
  # a user of this "hello.nix" module ENABLED this module
  # by setting "services.hello.enable = true;".
  config = mkIf cfg.enable {
    system.activationScript.pfctl = builtins.concatStringsSep ''echo "${pfctlConfig}" | pfctl -e -f --'' [mkIf cfg.logging.enable " -x ${loggingLevel} > ${logFile}"];
  };
}
