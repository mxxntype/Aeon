{
  pkgs,
  config,
  ...
}: let
  color = import ./theme.nix config.colorscheme;
in {
  imports = [
    ./plugins/tree-sitter.nix
    ./plugins/nvim-tree.nix
    ./plugins/completion
    ./plugins/autopairs.nix
    ./plugins/toggleterm.nix
    ./plugins/todo-comments.nix
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true; # Set EDITOR=nvim

    # TODO: Split this into relevant files with lists and lib.strings.concatStrings
    extraLuaConfig = ''
      --[[ Source colorscheme ]]------------------------------------------------
      vim.api.nvim_exec([[${color}]], false)

      --[[ Mappings ]]----------------------------------------------------------
      local map = vim.keymap.set

      -- Leader key
      map("", "<space>", "<nop>", {})
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "

      map("n", ";", ":", {})              -- ; enters command mode

      map("n", "<leader>w", ":w<cr>")     -- Save file

      -- Navigate within insert mode (en/ru)
      map("i", "<A-h>", "<left>")
      map("i", "<A-р>", "<left>")
      map("i", "<A-j>", "<down>")
      map("i", "<A-о>", "<down>")
      map("i", "<A-k>", "<up>")
      map("i", "<A-л>", "<up>")
      map("i", "<A-l>", "<right>")
      map("i", "<A-д>", "<right>")

      -- Nvim-comment
      -- map("n", "<leader>/", ":CommentToggle<cr>", {})       -- Comment one line
      -- map("x", "<leader>/", ":'<,'>CommentToggle<cr>", {})  -- Comment multiple lines in visual mode

      -- Nvim-tree
      map("n", "<leader>e", ":NvimTreeFocus<cr>", {})
      map("n", "<leader>l", ":NvimTreeToggle<cr>", {})

      -- Toggleterm
      map("n", "<A-i>", "<cmd>ToggleTerm<cr>", {})
      map("t", "<A-i>", "<cmd>ToggleTerm<cr>", {})

      --[[ Options ]]-----------------------------------------------------------
      --[[ Indenting ]]--
      vim.opt.shiftwidth = 2                            -- Change the number of space characters inserted for indentation
      vim.opt.tabstop = 2                               -- Insert 2 spaces for a tab
      vim.opt.softtabstop = 2                           -- No clue yet haha
      vim.opt.smarttab = true                           -- Makes tabbing smarter will realize you have 2 vs 4
      vim.opt.expandtab = true                          -- Converts tabs to spaces
      vim.opt.autoindent = true                         -- Good auto indent
      vim.opt.smartindent = false                       -- Makes indenting somewhat smarter? --[[ Search & Case sensitivity ]]--
      vim.opt.incsearch = true                          -- Sets incremental search
      vim.opt.ignorecase = true                         -- Ignores case when searching
      vim.opt.smartcase = true                          -- Turns on case sensitive search when letters are capitalized

      --[[ UI ]]--
      vim.opt.mouse = 'a'                               -- Enable mouse support
      vim.opt.clipboard = "unnamedplus"                 -- Use the system clipboard
      vim.opt.background = "dark"                       -- Tell vim what the background color looks like
      vim.opt.termguicolors = true                      -- Set term gui colors (not yet le)
      vim.opt.number = true                             -- Line numbers
      vim.opt.numberwidth = 6                           -- Line numbers amount
      vim.opt.wrap = true                               -- Line wrap
      vim.opt.relativenumber = false                    -- Vim’s absolute, relative and hybrid line numbers
      vim.opt.showtabline = 1                           -- Always show tabs
      vim.opt.cmdheight = 1                             -- More space for displaying messages
      vim.opt.foldenable = false                        -- Disable folding text
      -- vim.opt.virtualedit = "onemore"                   -- With This option you can move the cursor one character over the end
      -- vim.opt.shortmess:append "sI"                     -- Disable nvim intro

      --[[ Cursor ]]
      vim.opt.guicursor = "a:ver10-blinkon500-blinkoff500,n:block,v:block-blinkon0-blinkoff0,r-cr-o:hor10"
      vim.cmd [[
        autocmd VimEnter,VimResume * set guicursor=a:ver10-blinkon500-blinkoff500,n:block,v:block-blinkon0-blinkoff0,r-cr-o:hor10
        autocmd VimLeave,VimSuspend * set guicursor=a:hor10-blinkon500-blinkoff500
      ]] -- reset cursor style when exiting neovim

      --[[ Behaviour ]]--
      vim.opt.pumheight = 15                            -- Makes popup menu smaller
      vim.opt.ruler = true              	              -- Show the cursor position all the time
      vim.opt.conceallevel = 0                          -- See `` in markdown files
      vim.opt.laststatus=3                              -- Always display the status line
      vim.opt.title = true                              -- Show current filename
      vim.opt.splitbelow = true                         -- Horizontal splits will automatically be below
      vim.opt.splitright = true                         -- Vertical splits will automatically be to the right
      vim.opt.autochdir = true                          -- Your working directory will always be the same as your working directory
      -- vim.opt.iskeyword:append("-")                  -- Treat dash separated words as a word text object"

      --[[ Swap & Undo ]]--
      vim.opt.swapfile = false                          -- Swapfile
      vim.opt.undofile = false                          -- Persistent undo

      --[[ Autocomplete ]]--
      vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

      --[[ Memory & CPU ]]--
      vim.opt.updatetime = 0                            -- Faster completion
      vim.opt.hidden = true                             -- Required to keep multiple buffers open
      vim.opt.timeoutlen = 500                          -- By default timeoutlen is 1000 ms
      vim.opt.synmaxcol = 240                           -- Max column for syntax highlight

      --[[ Encoding ]]--
      vim.opt.encoding="utf-8"                          -- The encoding displayed
      vim.opt.fileencoding="utf-8"                      -- The encoding written to file

      --[[ Other ]]--
      vim.cmd [[set nocompatible]]                      -- Disable compatibility to old-time vi
    '';
  };
}
