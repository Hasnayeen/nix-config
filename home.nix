{ config, pkgs, inputs, ... }:

{
  fonts.fontconfig.enable = true;
  home.username = "hasnayeen";
  home.homeDirectory = "/home/hasnayeen";
  home.stateVersion = "25.11";
  home.packages = [
    pkgs.git
    pkgs.nixd
    pkgs.nushell
    pkgs.starship
    pkgs.fzf
    pkgs.ripgrep
    pkgs.atuin
    pkgs.bottom
    pkgs.zoxide
    pkgs.bat
    pkgs.dust
    pkgs.gnome-extension-manager
    pkgs.wmctrl
    pkgs.imagemagick

    pkgs.direnv
    pkgs.nix-direnv
    pkgs.python3
    pkgs.nodejs
    pkgs.pnpm

    pkgs.frankenphp

    pkgs.wezterm
    pkgs.claude-code

    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.tuicr

    pkgs.zed-editor
    pkgs.vscode
    pkgs.beekeeper-studio

    pkgs.graphite

    pkgs.kooha
    pkgs.proton-vpn

    pkgs.nerd-fonts.jetbrains-mono
  ];

  # home.sessionVariables = {
  # };

  programs.direnv = {
      enable = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Hasnayeen";
        email = "searching.nehal@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  systemd.user.services.frankenphp-run = {
    Unit = {
      Description = "Run frankenphp on session start";
      After = [ "network.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "/run/wrappers/bin/frankenphp run";
      WorkingDirectory = "/mnt/work/projects/php";
      Restart = "always";
      RestartSec = "3";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  xdg.desktopEntries.beekeeper = {
    name = "BeeKeeper";
    comment = "Beekeeper Studio";
    exec = "${pkgs.lib.strings.escapeShellArg "/home/Applications/Beekeeper-Studio-4.3.4.AppImage"} %u";
    type = "Application";
    icon = "beekeeper-studio";
    terminal = false;
  };

  xdg.desktopEntries.tldraw = {
    name = "tldraw";
    comment = "tldraw";
    exec = "${pkgs.lib.strings.escapeShellArg "/home/Applications/tldraw-offline-linux-x86_64.AppImage"} %u";
    type = "Application";
    icon = "tldraw";
    terminal = false;
  };

  xdg.desktopEntries.paper = {
    name = "Paper";
    comment = "Paper Design App";
    exec = "${pkgs.lib.strings.escapeShellArg "/home/Applications/Paper.AppImage"} %u";
    type = "Application";
    icon = "Paper App Icon 512";
    mimeType = [ "x-scheme-handler/paper" ];
    terminal = false;
  };

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/paper" = "paper.desktop";
  };
}
