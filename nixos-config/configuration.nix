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
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "planetes";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

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

fonts = {
    packages = with pkgs; [
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
    upower.enable = true;
    xserver.enable = true;
  };
  
  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  users.users.aria = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    neovim
    vim
    xwayland-satellite
    mako
    swaylock
    wl-clipboard
    fuzzel
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  system.stateVersion = "26.05";

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
