{
  pkgs,
  ...
}:

{
  # Minecraft server settings
  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers.vanilla = {
      enable = true;
      serverProperties = {
        # server-port = 43000;
        difficulty = 3;
        gamemode = 0;
        # max-players = 5;
        # motd = "NixOS Minecraft server!";
        white-list = true;
        # enable-rcon = true;
        # "rcon.password" = "hunter2";
      };
      whitelist = {
        Bliztle_ = "78cfe459-7775-441d-b0db-f05ae2a28895";
        Trixa42 = "a8de6c28-bebd-4147-836d-b1d0d849f1a8";
        SmollRed = "a05148bb-9cc0-4731-b341-92883e15ead0";
        icecoldgold773 = "5b15147f-4f57-4fea-98cc-3272ad3cbb75";
        OP_lama = "1c8e79b2-9e7d-4746-aef1-17725051d306";
        WappaDappa = "5c120274-840f-4c4f-8581-1aff51126f32";
        __Vind__ = "ecb0a611-c0bc-402a-b00b-5026c54ef756";
      };

      # Specify the custom minecraft server package
      # package = pkgs.fabricServers.fabric-1_21_1.override {
      #   loaderVersion = "0.16.10";
      # }; # Specific fabric loader version
      package = pkgs.vanillaServers.vanilla;

      # symlinks = {
      #   mods = pkgs.linkFarmFromDrvs "mods" (
      #     builtins.attrValues {
      #       Fabric-API = pkgs.fetchurl {
      #         url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/9YVrKY0Z/fabric-api-0.115.0%2B1.21.1.jar";
      #         sha512 = "e5f3c3431b96b281300dd118ee523379ff6a774c0e864eab8d159af32e5425c915f8664b1cd576f20275e8baf995e016c5971fea7478c8cb0433a83663f2aea8";
      #       };
      #       Backpacks = pkgs.fetchurl {
      #         url = "https://cdn.modrinth.com/data/MGcd6kTf/versions/Ci0F49X1/1.2.1-backpacks_mod-1.21.2-1.21.3.jar";
      #         sha512 = "6efcff5ded172d469ddf2bb16441b6c8de5337cc623b6cb579e975cf187af0b79291b91a37399a6e67da0758c0e0e2147281e7a19510f8f21fa6a9c14193a88b";
      #       };
      #     }
      #   );
      # };
    };
  };
}
