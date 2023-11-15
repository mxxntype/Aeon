# INFO: File explorer

{
  pkgs,
  ...
}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = nvim-tree-lua;
      type = "lua";
      config = /* lua */ ''
        require("nvim-tree").setup({
          renderer = {
            symlink_destination = false,
          },
          git = {
            enable = true,
            ignore = false,
            show_on_dirs = true,
            show_on_open_dirs = true,
            timeout = 400,
          },
        })
      '';
    }
  ];
}
