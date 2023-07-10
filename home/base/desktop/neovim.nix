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
      :let mapleader = " "

      let g:airline_theme='palenight'
      set background=dark
      colorscheme palenight

      nnoremap <C-f> :NERDTreeFind<CR>
      nnoremap <C-n> :NERDTree<CR>
      nnoremap <C-t> :NERDTreeToggle<CR>
      nnoremap <leader>n :NERDTreeFocus<CR>
      let NERDTreeShowHidden=1

      nmap <Leader>m :MarkdownPreview<CR>
      nmap <Leader>t :MarkdownPreviewToggle<CR>
      nmap <Leader>s :MarkdownPreviewStop<CR>

      autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
      autocmd VimEnter * NERDTree | wincmd p

      "Make template just plain text type
      au BufRead,BufNewFile *.template set filetype=text

      augroup autoformat_settings
        autocmd FileType html,css,sass,scss,less,json,js AutoFormatBuffer js-beautify
        autocmd FileType nix AutoFormatBuffer nixpkgs-fmt
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
      # https://github.com/nvim-treesitter/nvim-treesitter
      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      # Make your Vim/Neovim as smart as VS Code - https://github.com/neoclide/coc.nvim
      coc-html
      coc-tsserver
      coc-yaml
      # Faster buffers for coc. https://github.com/ms-jpq/coq_nvim
      coq_nvim
      # Editorconfig - https://github.com/editorconfig/editorconfig-vim
      editorconfig-vim
      # Super fast git decorations implemented purely in Lua. - https://github.com/lewis6991/gitsigns.nvim
      gitsigns-nvim
      # This plugin adds indentation guides to all lines (including empty lines). - https://github.com/lukas-reineke/indent-blankline.nvim
      indent-blankline-nvim
      # Hyperfocus-writing in Vim. - https://github.com/junegunn/limelight.vim
      limelight-vim # :LimeLight (also, consider :setlocal spell spelllang=en_us
      # Markdown preview - https://github.com/iamcco/markdown-preview.nvim
      markdown-preview-nvim # :MarkdownPreview
      # file system explorer for vim - https://github.com/preservim/nerdtree
      nerdtree
      # NB! ARCHIVED Shows Git status flags for files and folders in NERDTree. - https://github.com/Xuyuanp/nerdtree-git-plugin
      nerdtree-git-plugin
      #built-in formatters and allows new formatters to be registered by other plugins - https://github.com/google/vim-codefmt
      vim-codefmt
      #Adds filetype-specific icons to NERDTree files and folders, - https://github.com/ryanoasis/vim-devicons
      vim-devicons
      #git powertools - https://github.com/tpope/vim-fugitive
      vim-fugitive
      #Lean & mean status/tabline for vim that's light as air. - https://github.com/vim-airline/vim-airline
      vim-airline
      # Airline themes
      vim-airline-themes
      # General theme
      palenight-vim
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