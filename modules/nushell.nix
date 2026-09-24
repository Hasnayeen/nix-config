{ config, pkgs, androidComposition, ... }:
{
  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.config.buffer_editor = 'hx'
      $env.config.show_banner = false
      
      $env.config.hooks.env_change.PWD = [
          { ||
              if (which direnv | is-empty) {
                  return
              }
      
              direnv export json | from json | default {} | load-env
          }
      ]
      
      def create_left_prompt [] {
          let path_segment = if (is-admin) {
              $"(ansi red_bold)($env.PWD)"
          } else {
              $"(ansi green_bold)($env.PWD)"
          }
      
          $path_segment
      }
      
      def create_right_prompt [] {
          let time_segment = ([
              (date now | format date '%m/%d/%Y %r')
          ] | str join)
      
          $time_segment
      }
      
      # Use nushell functions to define your right and left prompt
      $env.PROMPT_COMMAND = { create_left_prompt }
      $env.PROMPT_COMMAND_RIGHT = { create_right_prompt }
      
      # The prompt indicators are environmental variables that represent
      # the state of the prompt
      $env.PROMPT_INDICATOR = { "〉" }
      $env.PROMPT_INDICATOR_VI_INSERT = { "" }
      $env.PROMPT_INDICATOR_VI_NORMAL = { "" }
      $env.PROMPT_MULTILINE_INDICATOR = { "::: " }
      # $env.TRANSIENT_PROMPT_COMMAND = "  "
      
      $env.ENV_CONVERSIONS = {
        "PATH": {
          from_string: { |s| $s | split row (char esep) | path expand -n }
          to_string: { |v| $v | path expand -n | str join (char esep) }
        }
        "Path": {
          from_string: { |s| $s | split row (char esep) | path expand -n }
          to_string: { |v| $v | path expand -n | str join (char esep) }
        }
      }
      
      
      $env.PATH = ($env.PATH | append '/home/hasnayeen/.local/share/pnpm/bin')
      $env.PATH = ($env.PATH | append '/home/hasnayeen/.config/composer/vendor/bin')
      $env.PATH = ($env.PATH | append '/home/hasnayeen/bin')
      $env.PATH = ($env.PATH | append '/home/hasnayeen/.npm-global')
      
      $env.EDITOR = "hx"
      $env.OLLAMA_MODELS = "/mnt/files/llm-models"
      $env.OLLAMA_API_KEY = "noop"
      
      $env.ANDROID_HOME = "${androidComposition.androidsdk}/libexec/android-sdk"
      $env.ANDROID_SDK_ROOT = "${androidComposition.androidsdk}/libexec/android-sdk"
      $env.GST_PLUGIN_SYSTEM_PATH_1_0 = (
          [
              "/etc/profiles/per-user/hasnayeen/lib/gstreamer-1.0"
          ] | append ($env.GST_PLUGIN_SYSTEM_PATH_1_0? | default "") | str join ":"
      )
      
      starship init nu | save -f ~/.cache/starship/init.nu
      export-env { $env.STARSHIP_CONFIG = ( $env.HOME | path join ".config" "starship" "starship.toml" ) }
      
      zoxide init nushell | save -f ~/.zoxide.nu
      
      use ~/.cache/starship/init.nu
      source ~/.zoxide.nu
      
      source ~/.config/nushell/git_aliases.nu
      source ~/.config/nushell/aliases.nu
      source ~/.config/nushell/scripts/atuin-init.nu
    '';
  };
}
