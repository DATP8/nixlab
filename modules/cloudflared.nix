{ ... }:
{
  services.cloudflared = {
    enable = true;
    certificateFile = "/var/lib/cloudflared/cert.pem";
    tunnels."b03730f8-4297-46ee-bf35-06794fadc431" = {
      default = "http_status:404";
      credentialsFile = "/var/lib/cloudflared/b03730f8-4297-46ee-bf35-06794fadc431.json";
      ingress = {
        "manfred.datalogi.net" = {
          service = "ssh://localhost:22";
        };
        "alvaro.datalogi.net" = {
          service = "http://localhost:8888";
        };
        "minecraft.datalogi.net" = {
          service = "tcp://localhost:25565";
        };
      };
    };
  };
}
