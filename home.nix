{ config, pkgs, inputs, ... }:

{
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts.sansSerif = [ "Noto Sans" "Noto Sans Bengali" ];
  home.username = "hasnayeen";
  home.homeDirectory = "/home/hasnayeen";
  home.stateVersion = "25.11";
  home.packages = [
    # cli
    pkgs.wget
    pkgs.git
    pkgs.wezterm
    pkgs.ghostty
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
    pkgs.xclip
    pkgs.witr # why a process/service/program is running

    # dev
    pkgs.direnv
    pkgs.nix-direnv
    pkgs.python3
    pkgs.nodejs
    pkgs.pnpm
    pkgs.frankenphp
    pkgs.nixd

    # ai
    pkgs.claude-code
    pkgs.llmfit
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.tuicr

    pkgs.ollama-cpu

    # desktop app
    pkgs.zed-editor
    pkgs.vscode
    pkgs.beekeeper-studio
    pkgs.brave
    pkgs.graphite
    pkgs.proton-vpn
    pkgs.obsidian
    pkgs.blender

    # kooha
    pkgs.kooha
    pkgs.gst_all_1.gstreamer
    pkgs.gst_all_1.gst-plugins-base
    pkgs.gst_all_1.gst-plugins-good
    pkgs.gst_all_1.gst-plugins-bad
    pkgs.gst_all_1.gst-plugins-ugly
    pkgs.gst_all_1.gst-libav
    # pkgs.gst_all_1.gst-vaapi

    # fonts
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.lohit-fonts.bengali
  ];

  home.sessionVariables = {
    OLLAMA_MODELS = "/mnt/files/llm-models";
    GST_PLUGIN_SYSTEM_PATH_1_0 = with pkgs.gst_all_1;
      pkgs.lib.concatStringsSep ":" [
        "${gstreamer}/lib/gstreamer-1.0"
        "${gst-plugins-base}/lib/gstreamer-1.0"
        "${gst-plugins-good}/lib/gstreamer-1.0"
        "${gst-plugins-bad}/lib/gstreamer-1.0"
        "${gst-plugins-ugly}/lib/gstreamer-1.0"
        "${gst-libav}/lib/gstreamer-1.0"
        # "${gst-vaapi}/lib/gstreamer-1.0"
      ];
  };

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

  programs.nushell.extraEnv = ''
    let gst_paths = [
      "${pkgs.gst_all_1.gstreamer}/lib/gstreamer-1.0"
      "${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0"
      "${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0"
      "${pkgs.gst_all_1.gst-plugins-bad}/lib/gstreamer-1.0"
      "${pkgs.gst_all_1.gst-plugins-ugly}/lib/gstreamer-1.0"
      "${pkgs.gst_all_1.gst-libav}/lib/gstreamer-1.0"
    ]
    $env.GST_PLUGIN_SYSTEM_PATH_1_0 = ($gst_paths | append ($env.GST_PLUGIN_SYSTEM_PATH_1_0? | default "") | str join ":")
  '';

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

  xdg.configFile."environment.d/10-gstreamer.conf".text = ''
    GST_PLUGIN_SYSTEM_PATH_1_0=/etc/profiles/per-user/hasnayeen/lib/gstreamer-1.0
  '';
}
