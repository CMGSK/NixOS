{
  pkgs,
  inputs,
  ...
}:

let
  krisp-patcher = pkgs.callPackage ./krisp-patcher.nix { };
in

{
  home.username = "miku";
  home.homeDirectory = "/home/miku";
  home.packages = with pkgs; [
    woeusb
    nur.repos.Ev357.helium
    krisp-patcher
    brave
    inputs.nixohess.packages.${pkgs.stdenv.hostPlatform.system}.stremio-linux-shell
    input-leap
    onlyoffice-desktopeditors
    youtube-music
    qbittorrent
    #rustdesk
    obs-studio
    bruno
    spaceship-prompt
    p7zip
    nwg-look
    duf
    vscode
    mpv
    btop
    bat
    hyfetch
    fastfetch
    discord
    ghostty
    libsForQt5.qt5ct
    kdePackages.qt6ct
    zsh
  ];

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        update = "sudo nixos-rebuild switch --flake";
	df = "duf";
	"cd.." = "cd ..";
	":q" = "exit";
	ni = "cd /etc/nixos";
	unzip = "7z x ";
	zip = "7z a ";
      };

      oh-my-zsh = {
        enable = false;
        plugins = [ "git" "sudo" "docker" "command-not-found" ];
        theme = ""; 
      };

      initContent = ''
      PROMPT='%F{#FFB5F5}[%n@%m]%f %F{#BDD6DE}%~%f $ '

      ZSH_THEME_GIT_PROMPT_PREFIX=" %F{blue}("
      ZSH_THEME_GIT_PROMPT_SUFFIX=")%f"
      ZSH_THEME_GIT_PROMPT_DIRTY=" %F{yellow}✗%f"
      ZSH_THEME_GIT_PROMPT_CLEAN=""

      autoload -U select-word-style
      select-word-style bash
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey "^H" backward-kill-word
      bindkey "^[[3;5~" kill-word
      '';
    };
  };


  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  home.stateVersion = "26.05";
}
