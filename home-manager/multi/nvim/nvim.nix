{ nixosConfig, config, pkgs, ... }:

let 
  nnn-nvim = pkgs.fetchFromGitHub {
    owner = "luukvbaal";
    repo = "nnn.nvim";
    rev = "4616ec65eb0370af548e356c3ec542c1b167b415";
    sha256 = "sha256-iJTN1g5uoS6yj0CZ6Q5wsCAVYVim5zl4ObwVyLtJkQ0=";
  };
in
  
{ 
  
  home.file."lsp.nix".target = ".config/nvim/lua/lsp.lua";
  home.file."lsp.nix".source = ./init.lua;
  
  programs.neovim = {
   
    enable = true;
    package = pkgs.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
   
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      nnn-nvim
      nvim-colorizer-lua
      which-key-nvim
      barbar-nvim
      nvim-web-devicons
      telescope-nvim
      vim-illuminate
      luasnip
      lualine-nvim
      lualine-lsp-progress
      telescope-ui-select-nvim
      nvim-treesitter
      indent-blankline-nvim
      aerial-nvim

      # required for lsp
      nvim-cmp
      cmp-buffer
      cmp-path
      cmp_luasnip
      lspkind-nvim
      rust-vim
      vim-nix
      nvim-lspconfig
      cmp-nvim-lsp
      trouble-nvim
      nvim-treesitter
    ];

    extraPackages = with pkgs; [
      rust-analyzer rustc  
      gopls
      clang-tools ccls 
      sumneko-lua-language-server
      python310Packages.python-lsp-server
      jdt-language-server 
      haskell-language-server
      rnix-lsp

      tmux # required for nnn
      pkg-config # required for rust-lsp - for whatever reason
    ];
   
    extraLuaConfig = ''
      require('lsp')
    '';
  };
}
