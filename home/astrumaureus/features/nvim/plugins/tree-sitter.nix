# INFO: Modern highlighting engine

{
  pkgs,
  ...
}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = nvim-treesitter.withAllGrammars;
      type = "lua";
      config = ''
        require("nvim-treesitter.configs").setup({
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
          incremental_selection = {
            enable = true,
          },
          indent = {
            enable = true,
          },
        })
      '';
    }
  ];
}
