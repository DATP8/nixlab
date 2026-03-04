{
  description = "Homelab NixOS Flake shared across all homelab devices";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";
    flake-utils.url = "github:numtide/flake-utils";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      deploy-rs,
      flake-utils,
      nix-minecraft,
      ...
    }:
    let
      nodes = [
        {
          hostname = "manfred";
          ssh_hostname = "manfred";
          system = "x86_64-linux";
          role = "server";
        }
      ];
    in
    {
      # --- Top-level nixosConfigurations ---
      nixosConfigurations = builtins.listToAttrs (
        map (node: {
          name = node.hostname;
          value = nixpkgs.lib.nixosSystem {
            specialArgs = {
              meta = node;
            };
            system = node.system;
            modules = [
              ./hosts/${node.hostname}/configuration.nix
              ./configuration.nix
              ./modules/minecraft.nix
              nix-minecraft.nixosModules.minecraft-servers
              {
                nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
              }
            ];
          };
        }) nodes
      );

      # --- Top-level deploy-rs config ---
      deploy.nodes = builtins.listToAttrs (
        map (node: {
          name = node.hostname;
          value = {
            hostname = node.ssh_hostname;
            sshUser = "manfred";
            remoteBuild = true;
            fastConnection = true;
            profiles.system = {
              user = "root";
              path = deploy-rs.lib.${node.system}.activate.nixos self.nixosConfigurations.${node.hostname};
            };
          };
        }) nodes
      );
    }
    # --- System-dependent outputs ---
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            deploy-rs.packages.${system}.deploy-rs
          ];
        };
      }
    );
}
