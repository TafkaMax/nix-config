{ inputs, outputs, nixpkgs, osConfig, config, lib, pkgs, ... }: {

  programs.neovim = {

    enable = true;
    coc.enable = true;
    coc.settings = {
      "languageserver" = {
        nix = {
          command = "nil";
          filetypes = [ "nix" ];
          rootPatterns = [ "flake.nix" ];
        };
      };
    };
    defaultEditor = true;
    extraConfig = ''
      set cursorline
      set laststatus=2
      set nobackup
      set noswapfile
      set relativenumber
      set wrap linebreak

      nnoremap <C-f> :NERDTreeFind<CR>
      nnoremap <C-n> :NERDTree<CR>
      nnoremap <C-t> :NERDTreeToggle<CR>
      nnoremap <leader>n :NERDTreeFocus<CR>
      let NERDTreeShowHidden=1

      autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
      autocmd VimEnter * NERDTree | wincmd p

      au BufRead,BufNewFile *.bqn setf bqn
      au BufRead,BufNewFile * if getline(1) =~ '^#!.*bqn$' | setf bqn | endif

      augroup autoformat_settings
        autocmd FileType html,css,sass,scss,less,json,js AutoFormatBuffer js-beautify
        autocmd FileType nix AutoFormatBuffer nixpkgs-fmt
        autocmd FileType rust AutoFormatBuffer rustfmt
        autocmd Filetype yaml AutoFormatBuffer yamlfmt
      augroup END
    '';
    extraLuaConfig = ''
      require('gitsigns').setup()
      require("indent_blankline").setup {
        show_current_context = true,
        show_current_context_start = true,
      }
      require'nvim-treesitter.configs'.setup {
        highlight = {
          enable = true,
          disable = { "nix" },
        }
      }
    '';
    extraPackages = with pkgs; [
      nil
      nixpkgs-fmt
      nodePackages.js-beautify
      yamlfmt
    ];
    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      coc-html
      coc-tsserver
      coc-yaml
      coq_nvim
      editorconfig-vim
      gitsigns-nvim
      indent-blankline-nvim
      limelight-vim # :LimeLight (also, consider :setlocal spell spelllang=en_us
      markdown-preview-nvim # :MarkdownPreview
      nerdtree
      nerdtree-git-plugin
      vim-codefmt
      vim-devicons
      vim-fugitive
    ];
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
  };

  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        trim_trailing_whitespace = true;
        insert_final_newline = false;
        max_line_width = 78;
        indent_style = "space";
        indent_size = 2;
      };
    };
  };

}