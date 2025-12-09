{ pkgs, ... }: {

  #DOCS: https://notashelf.github.io/nvf/options

  #BASE INSPIRATION FROM EXAMPLE CONFIG: https://github.com/NotAShelf/nvf/blob/main/configuration.nix

  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        viAlias = false; #Alias for vi
        vimAlias = true; #Alias for vim
        withNodeJs = true; #Whether to enable NodeJs support in the Neovim wrapper .

        globals = {
          editorconfig = true; #Enable editorconfig.
          mapleader = " "; #Default LEADER is SPACEBAR
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

        git = {
          enable = true;
          gitsigns.enable = true;
          gitsigns.codeActions.enable = false; # throws an annoying debug message
          neogit.enable = true; #https://github.com/NeogitOrg/neogit
        };

        treesitter = {
          enable = true;
          grammars = pkgs.vimPlugins.nvim-treesitter.allGrammars;
          context.enable = true;
        };

        lsp = {
          enable = true;

          formatOnSave = false;
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
          languages = [ "en" ];
          programmingWordlist.enable = false;
        };

        # https://notashelf.github.io/nvf/options.html#opt-vim.diagnostics.enable
        diagnostics = {
          enable = false;
          config = {
            underline.enable = false;
            virtual_lines.enable = false;
          };
        };

        binds = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };

        notify = {
          nvim-notify.enable = true;
        };

        # This section does not include a comprehensive list of available language modules.
        # To list all available language module options, please visit the nvf manual.
        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          # Languages that will be supported in default and maximal configurations.
          nix.enable = true;
          markdown.enable = true;

          # Languages that are enabled in the maximal configuration.
          bash.enable = true;
          clang.enable = true;
          css.enable = true;
          html.enable = true;
          sql.enable = true;
          java.enable = true;
          ts.enable = true;
          go.enable = true;
          lua.enable = true;
          python.enable = true;
          typst.enable = true;

          # Language modules that are not as common.
          ruby.enable = true;
          tailwind.enable = true;

        };

        autopairs.nvim-autopairs.enable = true;
        # nvf provides various autocomplete options. The tried and tested nvim-cmp
        # is enabled in default package, because it does not trigger a build. We
        # enable blink-cmp in maximal because it needs to build its rust fuzzy
        # matcher library.
        autocomplete = {
          nvim-cmp.enable = true;
        };

        telescope.enable = true;

        notes = {
          todo-comments.enable = true;
        };

        visuals = {
          nvim-scrollbar.enable = true;
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true;
          cinnamon-nvim.enable = true;
          fidget-nvim.enable = true;

          highlight-undo.enable = true;
          indent-blankline.enable = true;
          cellular-automaton.enable = false;
        };

        comments = {
          comment-nvim.enable = true; #https://github.com/numToStr/Comment.nvim?tab=readme-ov-file#-usage
        };

        assistant = {
          #TODO
        };

        dashboard = {
          dashboard-nvim.enable = false;
          alpha.enable = true; #https://github.com/goolord/alpha-nvim
        };

        minimap = {
          minimap-vim.enable = false;
          codewindow.enable = true; # lighter, faster, and uses lua for configuration: https://github.com/gorbit99/codewindow.nvim?tab=readme-ov-file#configuration
        };

        terminal = {
          toggleterm = {
            enable = true;
            lazygit.enable = true;
          };
        };

        utility = {
          diffview-nvim.enable = true;
          icon-picker.enable = true;
          surround.enable = true;
          leetcode-nvim.enable = true;
          multicursors.enable = true;
          smart-splits.enable = true;
          undotree.enable = true;
          nvim-biscuits.enable = true;

          motion = {
            hop.enable = true;
            leap.enable = true;
            precognition.enable = true;
          };
          images = {
            image-nvim.enable = false;
            img-clip.enable = true;
          };
        };
        ui = {
          borders.enable = true;
          noice.enable = true;
          colorizer.enable = true;
          illuminate.enable = true;
          breadcrumbs = {
            # https://github.com/LunarVim/breadcrumbs.nvim
            # Breadcrumbs is a plugin that works with nvim-navic to provide context about your code in the winbar.
            enable = true;
            # https://github.com/hasansujon786/nvim-navbuddy?tab=readme-ov-file#-customise
            # A simple popup display that provides breadcrumbs like navigation feature but in keyboard centric manner inspired by ranger file manager.
            navbuddy.enable = true;
          };
          smartcolumn = {
            # https://github.com/m4xshen/smartcolumn.nvim
            enable = true; #A Neovim plugin hiding your colorcolumn when unneeded.
          };
          fastaction.enable = true;
        };
        # https://notashelf.github.io/nvf/options.html#opt-vim.keymaps
        keymaps = [
           {
             key = "<leader>nb";
             mode = ["n" "x"];
             silent = true;
             action = "<cmd>Navbuddy<CR>";
             desc = "Open NavBuddy";
           }
         ];
      };
    };
  };
}
