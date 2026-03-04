{
  pkgs,
  meta,
  inputs,
  ...
}:
{
  imports = [
    ./modules/cloudflared.nix
    ./modules/desktop.nix
    ./modules/jupyter.nix
    ./modules/neovim.nix
    ./modules/shell.nix
  ];

  security.sudo.wheelNeedsPassword = false; # Replace this with sudo-over-ssh

  programs.nix-ld.enable = true; # Allow dynamic linking of nix packages

  networking.hostName = meta.hostname; # Define your hostname.

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "dk";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "dk-latin1";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.manfred = {
    isNormalUser = true;
    description = "manfred";
    extraGroups = [
      "networkmanager"
      "wheel"
      "media"
    ];
    packages = with pkgs; [ ];
    openssh.authorizedKeys.keys = [
      # Added this as deployment prompts yubikey 4 times per host
      # Yubikeys
      "sk-ecdsa-sha2-nistp256@openssh.com AAAAInNrLWVjZHNhLXNoYTItbmlzdHAyNTZAb3BlbnNzaC5jb20AAAAIbmlzdHAyNTYAAABBBNdyTSPteztylzzDebHqctbDo/XmoYI10JAkh+M0sSlevcvZbtFWID10D8Be89xFIHohLBk39i8nzTVbLAjP5IoAAAAEc3NoOg== yubikey-station"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKZr8Sjw7Bab9e7/8SEnrVJp48PwIOarYLQsstwacFQaAAAABHNzaDo= yubikey-float"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH3tQUrCi3I5hRkS1zeQ93nlo7o+5Xx0ZcoE0wxdtHXF bliztle@framework"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7qNRrY3q4/D2V/Ef4S7TJtcELcjpSG/bbrF/HRCM6x bliztle@omen"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDgHfK+dZURsgEUUWt9jek7c8D6+s6nDz582kFzpRUgB emilschneiderlorentzen@h307.aau1x.klient.slv.site.aau.dk"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIUFn/ed0lF/nXltFO827AACEB8H/okxl+mh9OSbDRd3 madsvind7@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILMYU38Uo72mPMxLqK6ypy7KZmKSrS8N9T0trZyRWMvi homie@homiepc"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINW45N7MLltlBjcvu/0lfi7SG6ARpKaW7bHRB699zuHA mikkel.tygesen@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJm28rKwV2R67AnnXNleZ5SqBLKpzx/l4EM7rSsuJHAw mguldb22@student.aau.dk"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    btop
    tmux
    git
    pam_u2f # General purpose pam u2f. Enough for yubikey 2fa
    ripgrep
    bat
    eza
    tldr
    cloudflared
    firefox
    uv
    (python3.withPackages (
      python-pkgs: with python-pkgs; [
        jupyterlab
      ]
    ))
    cudaPackages.cudatoolkit
    pciutils
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    80 # HTTP
    443 # HTTPS
  ];
}
