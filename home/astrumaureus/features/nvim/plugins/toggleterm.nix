# INFO: Neovim-integrated terminal

{
  pkgs,
  ...
}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = toggleterm-nvim;
      type = "lua";
      config = ''
        require("toggleterm").setup({
          -- size can be a number or function which is passed the current terminal
          size = function(term)
            if term.direction == "horizontal" then
              return 15
            elseif term.direction == "vertical" then
              return vim.o.columns * 0.4
            end
          end,
          direction = "float",
          float_opts = { border = "single" },
        })
      '';
    }
  ];
}
