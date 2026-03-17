{
  config,
  lib,
  ...
}: let
  ratholePort = 44133;
in {
  services.rathole = {
    enable = true;
    # Should be "client" on server behind NAT, and "server" on public server
    role = "client";
    settings = {
      client = {
        remote_addr = "minecraft.datalogi.net:${toString ratholePort}";
        services.minecraft.local_addr = "127.0.0.1:25565";
      };
      server = {
        bind_addr = "0.0.0.0:${toString ratholePort}";
        services.minecraft.bind_addr = "0.0.0.0:25565";
      };
    };
    # Should contain
    # ```
    # [server.services.minecraft]
    # token = "<token>"
    # [client.services.minecraft]
    # token = "<token>"
    # ```
    credentialsFile = "/var/lib/secrets/rathole/config.toml";
  };
  networking.firewall = let
    openPorts = lib.optionals (config.services.rathole.role == "server") [ratholePort 25565];
  in {
    allowedTCPPorts = openPorts;
    allowedUDPPorts = openPorts;
  };
}
