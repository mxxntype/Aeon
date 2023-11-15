# INFO: XMobar config

{
  config,
  ...
}: let
  inherit (config.theme) colors;
in {
  programs.xmobar = {
    enable = true;
    extraConfig = ''
      Config { overrideRedirect = False
             , font     = "xft:JetBrainsMono Nerd Font-10"
             , bgColor  = "#${colors.base}"
             , fgColor  = "#${colors.text}"
             , position = TopW L 95
             , commands = [ Run Weather "UUBW"
                              [ "--template", "<weather> <tempC>°C"
                              , "-L", "0"
                              , "-H", "25"
                              , "--low"   , "#${colors.yellow}"
                              , "--normal", "#${colors.green}"
                              , "--high"  , "#${colors.teal}"
                              ] 36000
                          , Run Cpu
                              [ "-L", "3"
                              , "-H", "50"
                              , "--normal", "#${colors.green}"
                              , "--high"  , "#${colors.teal}"
                              ] 10
                          , Run Alsa "default" "Master"
                              [ "--template", "<volumestatus>"
                              , "--suffix"  , "True"
                              , "--"
                              , "--on", ""
                              ]
                          , Run Memory ["--template", "Mem: <usedratio>%"] 10
                          , Run Swap [] 10
                          , Run Date "%a %Y-%m-%d <fc=#8be9fd>%H:%M</fc>" "date" 10
                          , Run XMonadLog
                          ]
             , sepChar  = "%"
             , alignSep = "}{"
             , template = "%XMonadLog% }{ %alsa:default:Master% | %cpu% | %memory% * %swap% | %UUBW% | %date% "
             }
    '';
  };

  # BUG: `trayer` does not respect any of these options
  services.trayer = {
    enable = true;
    settings = {
      edge = "top";
      align = "right";
      SetDockType = true;
      SetPartialStrut = true;
      expand = true;
      width = 10;
      transparent = true;
      tint = "0x${colors.base}";
      height = 18;
    };
  };
}
