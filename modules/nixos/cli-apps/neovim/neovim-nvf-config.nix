{
  pkgs,
  lib,
  namespace,
  ...
}:

with lib;
with lib.${namespace};
{

  #DOCS: https://notashelf.github.io/nvf/options

  #BASE INSPIRATION FROM EXAMPLE CONFIG: https://github.com/NotAShelf/nvf/blob/main/configuration.nix

  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        viAlias = false; # Alias for vi
        vimAlias = true; # Alias for vim
        withNodeJs = true; # Whether to enable NodeJs support in the Neovim wrapper .

        globals = {
          editorconfig = true; # Enable editorconfig.
          mapleader = " "; # Default LEADER is SPACEBAR
        };

        filetree = {
          nvimTree = {
            enable = true;
          };
        };

        git = {
          enable = true;
          gitsigns.enable = true;
          gitsigns.codeActions.enable = false; # throws an annoying debug message
          # Use LazyGit for now.
          neogit.enable = false; # https://github.com/NeogitOrg/neogit
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
          presets = {
            tailwindcss-language-server.enable = true;
          };
        };

        theme = {
          enable = true;
          name = "everforest"; # https://notashelf.github.io/nvf/options.html#opt-vim.theme.name
          style = "soft";
        };

        statusline = {
          lualine = {
            theme = "everforest"; # https://notashelf.github.io/nvf/options.html#opt-vim.statusline.lualine.theme
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

        # Notification Manager
        notify = {
          nvim-notify.enable = true; # https://github.com/rcarriga/nvim-notify
        };

        # project.nvim is an all in one neovim plugin written in lua that provides superior project management.
        projects = {
          project-nvim.enable = true; # https://github.com/ahmedkhalf/project.nvim
        };

        # This section does not include a comprehensive list of available language modules.
        # To list all available language module options, please visit the nvf manual.
        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          # Languages that will be supported in default and maximal configurations.
          nix = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };

          markdown = {
            enable = true;
            extensions = {
              render-markdown-nvim.enable = true;
            };
            format = {
              enable = true;
            };
            lsp.enable = true;
            treesitter.enable = true;
          };

          # Languages that are enabled in the maximal configuration.
          bash.enable = true;
          clang.enable = true;
          css.enable = true;
          hcl = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };
          html = {
            enable = true;
            treesitter = {
              enable = true;
              autotagHtml = true;
            };
          };
          sql.enable = true;
          java = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };
          typescript.enable = true;
          go.enable = true;
          lua.enable = true;
          python = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };
          typst.enable = true;

          # Language modules that are not as common.
          ruby.enable = true;
          terraform = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };
          yaml = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };

        };

        #https://github.com/windwp/nvim-autopairs
        autopairs.nvim-autopairs.enable = true;

        # nvf provides various autocomplete options. The tried and tested nvim-cmp
        # is enabled in default package, because it does not trigger a build. We
        # enable blink-cmp in maximal because it needs to build its rust fuzzy
        # matcher library.
        # https://cmp.saghen.dev/recipes#disable-per-filetype-buffer
        # Remove autocomplete for specific filetype
        autocomplete = {
          # https://github.com/hrsh7th/nvim-cmp
          # NB!
          nvim-cmp = {
            enable = true;
            # Use default option for now.
            #format = lib.generators.mkLuaInline ''
            #  function(entry, vim_item)
            #    vim_item.menu = (${toLuaObject config.vim.autocomplete.nvim-cmp.sources})[entry.source.name]
            #    return vim_item
            #  end
            #'';
          };
          # NB! Doesn't work with CodeCompletion-nvim yet!
          # https://github.com/NotAShelf/nvf/discussions/1076
          blink-cmp = {
            enable = false; # https://github.com/saghen/blink.cmp
            setupOpts = {
              completion = {
                documentation = {
                  auto_show = true;
                };
                menu = {
                  auto_show = true;
                };
              };
              keymap = {
                preset = "none";
              };
            };
          };
        };

        # Search Utility
        telescope.enable = true;

        notes = {
          todo-comments.enable = true;
        };

        visuals = {
          nvim-scrollbar.enable = true; # https://github.com/petertriho/nvim-scrollbar
          nvim-web-devicons.enable = true; # Icons #https://github.com/nvim-tree/nvim-web-devicons
          nvim-cursorline.enable = true;
          cinnamon-nvim.enable = true; # scrolling #https://github.com/declancm/cinnamon.nvim
          fidget-nvim.enable = true; # https://github.com/j-hui/fidget.nvim

          highlight-undo.enable = true; # https://github.com/tzachar/highlight-undo.nvim
          indent-blankline.enable = true; # https://github.com/lukas-reineke/indent-blankline.nvim
        };

        comments = {
          comment-nvim.enable = true; # https://github.com/numToStr/Comment.nvim?tab=readme-ov-file#-usage
        };

        dashboard = {
          dashboard-nvim.enable = false;
          alpha.enable = true; # https://github.com/goolord/alpha-nvim
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
          diffview-nvim.enable = true; # Git DiffView
          # Surround Selection in brackets or whatnow.
          surround.enable = true; # https://github.com/kylechui/nvim-surround
          # Allows creating multiple blocks at same time. Useful for coding duplicates
          multicursors.enable = true; # https://github.com/jake-stewart/multicursor.nvim
          # Allows moving around splits/screens.
          smart-splits.enable = true; # https://github.com/mrjones2014/smart-splits.nvim
          # Diff previewer window shows the difference between the current node and the node under the cursor.
          undotree.enable = true; # https://github.com/jiaoshijie/undotree
          # Every dev needs something sweet sometimes. Code Biscuits are in-editor annotations usually at the end of a closing tag/bracket/parenthesis/etc. They help you get the context of the end of that AST node so you don't have to navigate to find it.
          # NOT IN USE, I DONT LIKE IT FOR NOW.
          nvim-biscuits.enable = false; # https://github.com/code-biscuits/nvim-biscuits

          motion = {
            hop.enable = true; # https://github.com/smoka7/hop.nvim
            leap.enable = true; # https://codeberg.org/andyg/leap.nvim
            # I don't like this at all.
            precognition.enable = false; # https://github.com/tris203/precognition.nvim

          };
          images = {
            image-nvim.enable = false; # https://github.com/3rd/image.nvim
            # directly paste pics
            img-clip.enable = true; # https://github.com/hakonharnes/img-clip.nvim
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
            enable = true; # A Neovim plugin hiding your colorcolumn when unneeded.
          };
          fastaction.enable = true;
        };
        # https://notashelf.github.io/nvf/options.html#opt-vim.keymaps
        keymaps = [
          {
            key = "<leader>nb";
            mode = [
              "n"
              "x"
            ];
            silent = true;
            action = "<cmd>Navbuddy<CR>";
            desc = "Open NavBuddy";
          }
        ];

        # Neovim supports in-line syntax highlighting for multi-line strings.
        # Simply place the filetype in a /* comment */ before the line.
        luaConfigRC.nvim-fix-makefile = /* lua */ ''
          -- Call the Lua module from ./nvim/lua/nvim-fix-makefile
          enabled = function() return not vim.tbl_contains({ "makefile", "make" }, vim.bo.filetype) end

          -- via an autocmd
          vim.api.nvim_create_autocmd('BufEnter', {
            pattern = 'Makefile',
            callback = function()
              vim.b.completion = false
            end
          })
        '';

        # https://github.com/NotAShelf/nvf/discussions/1204
        # TODO fix this file not being found. luaConfigRC, is not deployed early enough?
        # additionalRuntimePaths
        #additionalRuntimePaths = [
        #  ./nvim-fix-makefile
        #];
      };
    };
  };
}
