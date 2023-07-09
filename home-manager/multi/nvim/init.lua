-- Aliases
local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt
local map = vim.api.nvim_set_keymap

-- Helpers
local function noremap(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.keymap.set(mode, lhs, rhs, options)
end

local function associate_filetype(glob, ft)
    cmd('autocmd BufRead,BufNewFile ' .. glob .. ' set filetype=' .. ft)
end
local function setup_filetype(ft, tab, opts)
    local cmdline = 'autocmd Filetype ' .. ft .. ' setlocal'
    if tab then cmdline = cmdline .. ' ts=' .. tab .. ' sw=' .. tab .. ' sts=' .. tab end
    if opts then cmdline = cmdline .. ' ' .. opts end -- FIXME: opts should be a table
    cmd(cmdline)
end

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

setup_filetype('bib', 1)
setup_filetype('c', 4)
setup_filetype('cpp', 2)
setup_filetype('dockerfile', 4)
setup_filetype('gitcommit', nil, 'colorcolumn=72')
setup_filetype('go', 4, 'noexpandtab')
setup_filetype('haskell', 4)
setup_filetype('java', 4)
setup_filetype('lua', 4)
setup_filetype('nix', 2)
setup_filetype('python', 4)
setup_filetype('sh', 4, 'noexpandtab')
setup_filetype('tex', 1)
setup_filetype('zsh', 4)

g.mapleader = ','

-- Display
opt.number = true -- line numbers
opt.clipboard = 'unnamedplus' -- use system clipboard
opt.ts = 4
opt.sw = 4
opt.sts = 4

-- Plugins

-- Status line
-- Fuzzy finder/option picker
require('telescope').setup {}
require("telescope").load_extension("ui-select")

-- Completion/Snippets
local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')
luasnip.config.set_config {
    enable_autosnippets = true,
}

cmp.setup {
    snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),

        ['<Tab>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif cmp.visible() then
                cmp.select_next_item()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            elseif cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' }
    }, {
        {
            name = 'buffer',
            option = {
                keyword_pattern = [[\k\+]], -- allow unicode multibyte characters
            },
        }
    }),
    formatting = {
        format = lspkind.cmp_format({
            with_text = false,
            maxwidth = 50,
        })
    },
}

-- LSP
local lsp = require('lspconfig')

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    update_in_insert = true, -- update suggestions in insert mode
})

for type, icon in pairs({ Error = '', Warn = '', Hint = '󰏫', Info = '' }) do
    fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "Diagnostic" .. type })
end

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap = true, silent = true }

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', require("telescope.builtin").lsp_definitions, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', require("telescope.builtin").lsp_implementations, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<Leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
    vim.keymap.set('n', '<Leader>D', require("telescope.builtin").lsp_type_definitions, opts)
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<Leader>d', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, opts)
    vim.keymap.set('n', '<Leader>f', function() vim.lsp.buf.format{ async = true } end, opts)

    require('illuminate').on_attach(client)
    vim.keymap.set('n', '<a-n>', function() require("illuminate").next_reference{wrap=true} end, opts)
    vim.keymap.set('n', '<a-p>', function() require("illuminate").next_reference{reverse=true,wrap=true} end, opts)
end

lsp.clangd.setup {
    on_attach = on_attach,
}
lsp.gopls.setup {
    on_attach = on_attach,
}
lsp.hls.setup {
    on_attach = on_attach,
    filetypes = { 'haskell', 'lhaskell', 'cabal' },
    root_dir = lsp.util.root_pattern('*.cabal', 'stack.yaml', 'cabal.project', 'package.yaml', 'hie.yaml', '.git'),
}
lsp.jdtls.setup {
    on_attach = on_attach,
    cmd = {'jdt-language-server', '-configuration', '/home/snd/.cache/jdtls/config', '-data', '/home/snd/.cache/jdtls/workspace'}, -- copied from upstream, but changed executable name
}
lsp.pylsp.setup {
    on_attach = on_attach,
}
lsp.rnix.setup {
    on_attach = on_attach,
}
lsp.rust_analyzer.setup {
    on_attach = on_attach,
    settings = {
        ['rust-analyzer'] = {
            checkOnSave = {
                command = 'clippy',
            },
        },
    },
}
lsp.lua_ls.setup {
    on_attach = on_attach,
    settings = {
        Lua = {
        runtime = {
            version = 'LuaJIT',
        },
        diagnostics = {
            globals = {'vim'},
        },
        workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = {
            enable = false,
        },
    },
  },
}

-- Trouble
require('trouble').setup {}
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", {silent = true, noremap = true})
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", {silent = true, noremap = true})
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", {silent = true, noremap = true})
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", {silent = true, noremap = true})
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", {silent = true, noremap = true})
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", {silent = true, noremap = true})

-- VimTeX
g.tex_flavor = 'latex'
g.vimtex_view_method = 'zathura'
g.tex_conceal = 'abdmg'

-- this disables some helful warnings that often have a reason why I ignore them
g.vimtex_quickfix_ignore_filters = {
    [[Underfull \\hbox (badness [0-9]*) in ]],
    [[Overfull \\hbox ([0-9]*.[0-9]*pt too wide) in ]],
    [[Overfull \\vbox ([0-9]*.[0-9]*pt too high) detected ]],
    [[Package hyperref Warning: Token not allowed in a PDF string]],
    [[Package typearea Warning: Bad type area settings!]],
}

g.vimtex_syntax_custom_cmds = {
    {
        name = 'llbracket',
        mathmode = true,
        concealchar = '⟦',
    },
    {
        name = 'rrbracket',
        mathmode = true,
        concealchar = '⟧',
    },
}

-- When using math environments vim does not know if if it currently is in one or outside of one
-- unless it parses the file from the start.
-- Parsing the file from the start each time fixes this
-- but leads to a performance drop (depending on the number of lines).
-- Also, somehow using FileType tex does not work, so this will enable slow syntax highlighting
-- everywhere once a *.tex file is opened.
cmd([[autocmd BufEnter *.tex syntax sync fromstart]])

-- rust.vim
g.rustfmt_autosave_if_config_present = 1
g.rust_fold = 1
noremap('n', '<Leader>rt', ':RustTest<CR>')

-- Markdown
g.vim_markdown_folding_disabled = 1

-- Tree Sitter
require('nvim-treesitter.configs').setup {
	highlight = {
	    enable = true,
	    additional_vim_regex_highlighting = false,
	},
	indent = {
	    enable = true,
	},
}

-- indent-blankline
opt.termguicolors = true
cmd [[highlight IndentBlanklineIndent1 guifg=#98C379 gui=nocombine]]
cmd [[highlight IndentBlanklineIndent2 guifg=#E96C75 gui=nocombine]]
cmd [[highlight IndentBlanklineIndent3 guifg=#C678DD gui=nocombine]]
cmd [[highlight IndentBlanklineIndent4 guifg=#61AFEF gui=nocombine]]
cmd [[highlight IndentBlanklineIndent5 guifg=#56B6C2 gui=nocombine]]
cmd [[highlight IndentBlanklineIndent6 guifg=#282C34 gui=nocombine]]

opt.list = true
opt.listchars:append "space:⋅"
opt.listchars:append "eol:↴"

require("indent_blankline").setup {
    space_char_blankline = " ",
    char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
    },
}

-- Lualine
require('lualine').setup {
    sections = {
		lualine_c = {
			'lsp_progress'
		}
	}
}

-- Aerial
require('aerial').setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
    layout = {
        default_direction = "right",
        min_width = { 0.2 },
    },
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle<CR>')

-- Colorizer
require('colorizer').setup {}

-- Theme
require("catppuccin").setup({
	flavour = "macchiato",
	transparent_background = false,
})
vim.cmd.colorscheme "catppuccin"

-- which-key
require('which-key').setup {}

-- barbar
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
-- Re-order to previous/next
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
-- Goto buffer in position...
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
-- Pin/unpin buffer
map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
-- Close buffer
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
-- Sort automatically by...
map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used

-- nnn
require("nnn").setup{}
vim.keymap.set("n", "<leader>nn", "<cmd>NnnPicker %:p:h<cr>", {silent = true, noremap = true})
