{ pkgs, ... }: {

  #DOCS: https://notashelf.github.io/nvf/options

  programs.nvf = {
    enable = true;
    defaultEditor = true;
    settings = {
      vim = {
        viAlias = false;
        vimAlias = true;
        withNodeJs = true;
        globals = {
          editorconfig = true;
          mapleader = " ";
        };
        filetree = {
          nvimTree = {
            enable = true;
            setupOpts = {
              actions = {

              };
              git = {
                enable = true;
              };
            };
          };
        };
        treesitter = {
          enable = true;
          grammars = pkgs.vimPlugins.nvim-treesitter.allGrammars;
        };
        lsp = {
          enable = true;

          formatOnSave = true;
          lspkind.enable = false;
          lightbulb.enable = true;
          lspsaga.enable = false;
          trouble.enable = true;
          lspSignature.enable = false; # conflicts with blink in maximal
          otter-nvim.enable = true;
          nvim-docs-view.enable = true;
        };
        theme = {
          enable = true;
          name = "everforest"; #https://notashelf.github.io/nvf/options.html#opt-vim.theme.name
          style = "soft";
        };
        statusline = {
          lualine = {
            theme = "everforest"; #https://notashelf.github.io/nvf/options.html#opt-vim.statusline.lualine.theme
          };
        };
        spellcheck = {
          # TODO We need to install wordlist files, before enabling.
          enable = false;
          programmingWordlist.enable = false;
        };
        #vim.keymaps = [
        #   {
        #     key = "s";
        #     mode = "n";
        #     silent = false;
        #     action = "nvim-tree.api.node.open.vertical";
        #   }
        #   {
        #     key = "i";
        #     mode = "n";
        #     silent = false;
        #     action = "nvim-tree.api.node.open.horizontal";
        #   }
        # ];
        assistant = {
        };
      };
    };
  };
}