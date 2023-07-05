# INFO: XMonad config

{
  config,
  pkgs,
  ...
}: let
  inherit (config.colorscheme) colors;
in {
  xsession.windowManager.xmonad = {
    config = pkgs.writeText "xmonad.hs" ''
      import XMonad

      import XMonad.Util.EZConfig
      import XMonad.Util.Ungrab
      import XMonad.Util.SpawnOnce

      import XMonad.Hooks.EwmhDesktops
      import XMonad.Hooks.DynamicLog
      import XMonad.Hooks.StatusBar
      import XMonad.Hooks.StatusBar.PP



      --[[ Layouts ]]--
      import XMonad.Layout.Gaps
      import XMonad.Layout.Spacing
      import XMonad.Layout.Magnifier

      import XMonad.Layout.ThreeColumns
      import XMonad.Layout.Fullscreen

      myLayout = fullscreenFull $ spacing 16 $ tiled ||| Mirror tiled ||| Full ||| threeCol
        where
          threeCol  = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
          tiled     = Tall nmaster delta ratio
          nmaster   = 1       -- Default amount of windows in the master pane
          delta     = 3/100   -- Resize steps (screen percentage)
          ratio     = 1/2     -- Default master pane size (screen percentage)



      main :: IO ()
      main = xmonad $ ewmhFullscreen $ ewmh $ xmobarProp $ def
          {
            modMask = mod4Mask
          , borderWidth         = 2
          , normalBorderColor   = "#${colors.base03}"
          , focusedBorderColor  = "#${colors.base09}"

          , startupHook = do
              spawnOnce "nvidia-offload picom --experimental-backends"
              spawnOnce "xrandr --output eDP-1 --gamma 0.7"
              spawnOnce "feh --bg-scale ~/Images/Wallpapers/output-1-landscape.png"

          , layoutHook = myLayout
          }
        `additionalKeysP`
          [ ("C-S-1", spawn "nvidia-offload wezterm start --always-new-process" )
          , ("C-S-2", spawn "nvidia-offload gimp"                               )
          , ("C-S-3", spawn "nvidia-offload librewolf"                          )
          , ("C-S-4", spawn "nvidia-offload kotatogram-desktop"                 )
          , ("C-S-5", spawn "nvidia-offload libreoffice"                        )
          , ("C-S-6", spawn "virt-manager"                                      )
          , ("C-S-7", spawn "nvidia-offload prismlauncher"                      )
          , ("C-S-8", spawn "keepassxc"                                         )
          , ("C-S-9", spawn "nvidia-offload freetube"                           )

          , ("C-<Print>", unGrab *> spawn "scrot -s")
          ]
    '';
  };
}
