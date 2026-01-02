{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];
  
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [
    "ntsync"
  ];

  networking.hostName = "crypton";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Madrid";
  nixpkgs.config.allowUnfree = true;

  hardware = {
    bluetooth.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ 
      "noto-fonts"
      "corefonts"
    ];

  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
      corefonts
      noto-fonts
      nerd-fonts.jetbrains-mono
      noto-fonts-cjk-sans
      source-sans-pro
      source-serif-pro
    ];

#    fontconfig = {
#      antialias = true;
#      cache32Bit = true;
#      hinting.enable = true;
#      hinting.autohint = true;
#      defaultFonts = {
#        serif = [ "Source Serif Pro" ];
#        sansSerif = [ "Source Sans Pro" ];
#        monospace = [ "JetBrainsMono Nerd Font" ];
#      };
#    };
  };  


  security.rtkit.enable = true;

  programs = {
    zsh.enable = true;
    git.enable = true;
    niri.enable = true;
    thunar.enable = true;
    steam.enable = true;
  };

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      wireplumber.enable = true;
    };

    mullvad-vpn = {
    	enable = true;
	package = pkgs.mullvad-vpn;
    };

    displayManager.gdm.enable = true;

    desktopManager.gnome.enable = true;
    gnome.core-apps.enable = false;
    gnome.core-developer-tools.enable = false;
    gnome.games.enable = false;

    upower.enable = true;
    xserver.enable = true;
  };
  
  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  users.users.miku = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    gnome-keyring
    neovim
    vim
    xwayland-satellite
    #mako
    swaylock
    wl-clipboard
    fuzzel
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

  system.stateVersion = "26.05";

  nix = {
     gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;

      trusted-users = [
        "root"
        "miku"
      ];

      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
      ];
      warn-dirty = false;

      # Binary caches
      substituters = [
        "https://cache.nixos.org/"
        "https://cache.garnix.io/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];

      # Avoid unwanted garbage collection when using nix-direnv
      keep-outputs = true;
      keep-derivations = true;
    };
  };
}
