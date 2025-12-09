{ pkgs, ... }: {

  #DOCS: https://notashelf.github.io/nvf/options

  programs.nvf = {
    enable = true;
    defaultEditor = true;
    settings = {
      vim.viAlias = false;
      vim.vimAlias = true;
      vim.withNodeJs = true;
      vim.globals = {
        editorconfig = true;
        mapleader = " ";
      };
      vim.filetree = {
        nvimTree = {
          enable = true;
        };
      };
      vim.treesitter = {
        enable = true;
        grammars = pkgs.vimPlugins.nvim-treesitter.allGrammars;
      };
      vim.lsp = {
        enable = true;
      };
      vim.theme = {
        enable = true;
        name = "everforest"; #https://notashelf.github.io/nvf/options.html#opt-vim.theme.name
        style = "soft";
      };
      vim.statusline = {
        lualine = {
          theme = "everforest"; #https://notashelf.github.io/nvf/options.html#opt-vim.statusline.lualine.theme
        };
      };
       vim.keymaps = [
         {
           key = "<leader>s";
           mode = "n";
           silent = false;
           action = "nvim-tree.api.node.open.vertical";
         }
         {
           key = "<leader>i";
           mode = "i";
           silent = false;
           action = "nvim-tree.api.node.open.horizontal";
         }
       ];
    };
  };
  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        trim_trailing_whitespace = true;
        insert_final_newline = true;
        max_line_width = 78;
        indent_style = "space";
        indent_size = 4;
      };
      "Makefile" = {
        indent_style = "tab";
      };
      "*.{yml,yaml}" = {
        indent_size = 2;
      };
      "*.json" = {
        indent_size = 2;
      };
      "*.nix" = {
        indent_size = 2;
      };
    };
  };
}
