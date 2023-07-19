# INFO: Colorizer

{
  pkgs,
  ...
}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = nvim-colorizer-lua;
      type = "lua";
      config = ''
        require("colorizer").setup({});
      '';
    }
  ];
}
