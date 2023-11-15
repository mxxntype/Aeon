# INFO: Nix-friendly LSP for Neovim

{
  pkgs,
  ...
}: {
  programs.neovim.plugins = with pkgs.vimPlugins; [

    # Core dependency
    nvim-lspconfig

    {
      plugin = lazy-lsp-nvim;
      type = "lua";
      config = /* lua */ ''
        require("lazy-lsp").setup({
          excluded_servers = {
            "sqls",       -- Complains on startup, should be `sqlls`
            "omnisharp",  -- Just completely unusable
          },
        });
      '';
    }
  ];
}
