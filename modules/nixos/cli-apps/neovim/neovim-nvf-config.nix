{ pkgs, ... }: {

  #DOCS: https://notashelf.github.io/nvf/options

  programs.nvf = {
    enable = true;
    settings = {
      vim.viAlias = false;
      vim.vimAlias = true;
      vim.withNodeJs = true;
      vim.treesitter = {
        enable = true;
        grammars = pkgs.vimPlugins.nvim-treesitter.allGrammars;
      };
      vim.lsp = {
        enable = true;
      };
      vim.theme = {
        enable = true;
        name = "palenight";

      };
      vim.statusline = {
        lualine = {
          theme = "palenight";
        };
      };
    };
  };
}
