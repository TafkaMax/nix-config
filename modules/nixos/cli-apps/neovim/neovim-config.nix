{ inputs, outputs, osConfig, config, lib, pkgs, ... }: {

  #https://nixos.wiki/wiki/Vim

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

      " Give more space for displaying messages.
      set cmdheight=3

      " Smart way to move between windows
      map <C-j> <C-W>j
      map <C-k> <C-W>k
      map <C-h> <C-W>h
      map <C-l> <C-W>l


      " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
      set updatetime=300
      :let mapleader = " "

      if (has("nvim"))
        "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
      endif

      "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
      "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
      " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
      if (has("termguicolors"))
        set termguicolors
      endif

      let g:airline_theme = "palenight"
      set background=dark
      colorscheme palenight
      " Italics for my favorite color scheme
      let g:palenight_terminal_italics=1


      " NerdTree configuration.
      nnoremap <C-f> :NERDTreeFind<CR>
      nnoremap <C-n> :NERDTree<CR>
      nnoremap <C-t> :NERDTreeToggle<CR>
      nnoremap <leader>n :NERDTreeFocus<CR>
      autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
      autocmd VimEnter * NERDTree | wincmd p
      let NERDTreeShowHidden=1

      " MarkdownPreview configuration.
      nmap <Leader>m :MarkdownPreview<CR>
      nmap <Leader>t :MarkdownPreviewToggle<CR>
      nmap <Leader>s :MarkdownPreviewStop<CR>

      "Make template just plain text type
      au BufRead,BufNewFile *.template set filetype=text

      " Typescript configuration.
      " Setfiletype as typescript
      au BufNewFile,BufRead *.ts setlocal filetype=typescript
      "set filestypes as typescriptreact
      au BufNewFile,BufRead *.tsx,*.jsx setlocal filetype=typescriptreact

      " Use K to show documentation in preview window.
      nnoremap <silent> K :call ShowDocumentation()<CR>

      function! ShowDocumentation()
        if CocAction('hasProvider', 'hover')
          call CocActionAsync('doHover')
        else
          call feedkeys('K', 'in')
        endif
      endfunction


      " Highlight the symbol and its references when holding the cursor.
      autocmd CursorHold * silent call CocActionAsync('highlight')

      " Remap <C-f> and <C-b> for scroll float windows/popups.
      if has('nvim-0.4.0') || has('patch-8.2.0750')
        nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
        inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
        inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
        vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
        vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
      endif

      " Use tab for trigger completion with characters ahead and navigate.
      " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
      " other plugin before putting this into your config.
      "inoremap <silent><expr> <TAB>
      "      \ pumvisible() ? "\<C-n>" :
      "      \ <SID>check_back_space() ? "\<TAB>" :
      "      \ coc#refresh()
      "inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

      inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ CheckBackspace() ? "\<Tab>" :
            \ coc#refresh()
      inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

      function! CheckBackspace() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
      endfunction

      " Add `:Format` command to format current buffer.
      command! -nargs=0 Format :call CocActionAsync('format')

      " Add `:Fold` command to fold current buffer.
      command! -nargs=? Fold :call     CocAction('fold', <f-args>)

      " Add `:OR` command for organize imports of the current buffer.
      command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

      " Mappings for CocList
      " CocList command all expect a 'c' button after 'leader'
      " Show all diagnostics.
      noremap <silent><nowait><leader>cd :<C-u>CocList diagnostics<cr>
      " Manage extensions.
      nnoremap <silent><nowait><leader>ce  :<C-u>CocList extensions<cr>
      " Show commands.
      nnoremap <silent><nowait><leader>cc  :<C-u>CocList commands<cr>
      " Find symbol of current document.
      nnoremap <silent><nowait><leader>co  :<C-u>CocList outline<cr>
      " Search workspace symbols.
      nnoremap <silent><nowait><leader>cs  :<C-u>CocList -I symbols<cr>
      " Do default action for next item.
      nnoremap <silent><nowait><leader>cn  :<C-u>CocNext<CR>
      " Do default action for previous item.
      nnoremap <silent><nowait><leader>cp  :<C-u>CocPrev<CR>
      " Resume latest coc list.
      nnoremap <silent><nowait><leader>cr  :<C-u>CocListResume<CR>


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
      coc-emmet
      coc-css
      coc-json
      coc-pyright
      coc-eslint
      coc-yank
      coc-git
      typescript-vim
      vim-jsx-typescript
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
