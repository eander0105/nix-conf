{ inputs, outputs, config, pkgs, ... } :

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
    ../../modules/UI/gnome.nix
    ./home.nix
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  services.xserver.videoDrivers = [ "modesetting" ];

  # Bootloader
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "nixos"; # "castor"
    networkmanager = {
      enable = true;
      appendNameservers = [ "8.8.8.8" ];
    };

    # wireless.enable = true;
    extraHosts = ''
      127.0.0.1 nixos castor
    '';
  };

  time.timeZone = "Europe/Stockholm";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "sv_SE.UTF-8";
      LC_IDENTIFICATION = "sv_SE.UTF-8";
      LC_MEASUREMENT = "sv_SE.UTF-8";
      LC_MONETARY = "sv_SE.UTF-8";
      LC_NAME = "sv_SE.UTF-8";
      LC_NUMERIC = "sv_SE.UTF-8";
      LC_PAPER = "sv_SE.UTF-8";
      LC_TELEPHONE = "sv_SE.UTF-8";
      LC_TIME = "sv_SE.UTF-8";
    };
  };

  services.printing.enable = true;

  users.users.emil = {
    initialPassword = "qwerty";
    isNormalUser = true;
    description = "Emil Andersson";
    extraGroups = [ "networkmanager" "wheel" "input" "audio" "docker" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  services.envfs.enable = true;

  # System-wide packages
  environment.systemPackages = with pkgs; [
    git
    vim

    ghostty
    jetbrains-mono

    # wofi

    docker
    docker-compose
    gnumake
    nodejs
    mkcert
    nssTools
    # android-studio

    python314
    python314Packages.sqlalchemy

    go
    # Ebitengiene deps
    gcc

    discord
  ];

  environment.sessionVariables = {
    GSK_RENDERER="gl";
  };

  # python3.12's "doc" output currently fails to build (upstream docutils/sphinx
  # incompatibility), and it gets pulled in by default since documentation.doc.enable
  # installs the doc output of every systemPackage. Disable to unblock builds.
  documentation.doc.enable = false;

  # programs.wofi.enable = true;
  programs.nix-ld.enable = true;

  services.flatpak.enable = true;
  services.teamviewer.enable = true;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if ((action.id == "org.freedesktop.login1.suspend" ||
           action.id == "org.freedesktop.login1.hibernate" ||
           action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
           action.id == "org.freedesktop.login1.hibernate-multiple-sessions") &&
          subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  virtualisation.docker = {
    enable = true;
    # rootless = {
    #   enable = true;
    #   setSocketVariable = true;
    # };
  };

  # Disable the firewall
  networking.firewall.enable = false;

  ## 
  system.stateVersion = "24.11";
}
