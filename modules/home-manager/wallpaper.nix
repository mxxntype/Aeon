{
  pkgs,
  ...
}: {
  home.packages = [
    (pkgs.writeShellScriptBin "set-wallpaper" ''
      WALLPAPER_FILE="$HOME/.wallpaper"
      NEW_WALLPAPER_PATH=$(realpath $1)

      function ping_new() {
        if [ -f "$NEW_WALLPAPER_PATH" ]; then
          echo "[TRACE] $NEW_WALLPAPER_PATH look valid"
          return 0;
        fi
        echo "[ERR] $NEW_WALLPAPER_PATH does not exist or is not an image"
        return 1;
      }

      function update_with_new() {
        if [ -L "$WALLPAPER_FILE" ]; then
          echo "[TRACE] $WALLPAPER_FILE exists, overwriting with a new link"
          unlink "$WALLPAPER_FILE"
        elif [ -e "$WALLPAPER_FILE" ]; then
          echo "[WARN] $WALLPAPER_FILE is an image itself and not a link to an image"
          mv "$WALLPAPER_FILE" "$WALLPAPER_FILE-backup"
        else
          echo "[WARN] $WALLPAPER_FILE not found, creating new one"
        fi
        ln -s "$NEW_WALLPAPER_PATH" "$WALLPAPER_FILE" &&
        echo "[TRACE] all good."
      }

      ping_new && update_with_new
    '')
  ];
}
