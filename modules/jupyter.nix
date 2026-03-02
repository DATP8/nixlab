{ pkgs, ... }:
{
  users.groups.jupyter-users = { };
  users.users.manfred.extraGroups = [ "jupyter-users" ];
  users.users.jupyter.extraGroups = [ "jupyter-users" ];

  systemd.tmpfiles.rules = [
    "d /var/lib/jupyter 2775 jupyter jupyter-users -"
  ];
  systemd.services.jupyter.serviceConfig = {
    UMask = "0002";
  };

  services.jupyter = {
    enable = true;
    command = "jupyter lab";
    password = "argon2:$argon2id$v=19$m=10240,t=10,p=8$xHCdewiogD9n5+QAKyJaOQ$hhuScN7/YkLz217Shzg5cSptugJ8n6Zeo5frVr9QL4Y";
    ip = "127.0.0.1";
    notebookConfig = ''
      c.ServerApp.allow_remote_access = True
      c.ServerApp.trust_xheaders = True
    '';
    kernels = {
      nix-python = {
        displayName = "Nix Python";
        argv =
          let
            myPython = pkgs.python3.withPackages (
              ps: with ps; [
                numpy
                pandas
                matplotlib
                torch
                ipykernel
              ]
            );
          in
          [
            "${myPython}/bin/python"
            "-m"
            "ipykernel_launcher"
            "-f"
            "{connection_file}"
          ];
        language = "python";
      };

      qiaskit-permutation-test = {
        displayName = "Qiskit Permutation Test (uv)";
        argv = [
          "/var/lib/jupyter-kernels/qiskit_permutation_test/.venv/bin/python"
          "-m"
          "ipykernel_launcher"
          "-f"
          "{connection_file}"
        ];
        language = "python";
      };
    };
    extraPackages = with pkgs; [
      python3Packages.jupyter-collaboration
    ];
    extraEnvironmentVariables = {
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    };
  };
}
