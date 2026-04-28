# Neovim commands (NVF)

NB! KEYMAPPINGS

`:TeleScope keymaps`

## LEADER

LEADER is SPACEBAR

## SIDEBAR

`LEADER + T`

## MINIMAP (RIGHT SIDE SHOWS OVERVIEW OF FILE)

```
<leader>mo - open the minimap
<leader>mc - close the minimap
<leader>mf - focus/unfocus the minimap
<leader>mm - toggle the minimap
```


## smart-splits

Allows moving around windows.

Docs: https://github.com/mrjones2014/smart-splits.nvim?tab=readme-ov-file#key-mappings

A is ALT

C is CTRL


```
-- recommended mappings

-- resizing splits
-- these keymaps will also accept a range,
-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
-- moving between splits
vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
vim.keymap.set('n', '<C-\\>', require('smart-splits').move_cursor_previous)
-- swapping buffers between windows
vim.keymap.set('n', '<leader><leader>h', require('smart-splits').swap_buf_left)
vim.keymap.set('n', '<leader><leader>j', require('smart-splits').swap_buf_down)
vim.keymap.set('n', '<leader><leader>k', require('smart-splits').swap_buf_up)
vim.keymap.set('n', '<leader><leader>l', require('smart-splits').swap_buf_right)
```

## Comments

https://github.com/numToStr/Comment.nvim?tab=readme-ov-file#-usage

```
# Linewise

`gcw` - Toggle from the current cursor position to the next word
`gc$` - Toggle from the current cursor position to the end of line
`gc}` - Toggle until the next blank line
`gc5j` - Toggle 5 lines after the current cursor position
`gc8k` - Toggle 8 lines before the current cursor position
`gcip` - Toggle inside of paragraph
`gca}` - Toggle around curly brackets

# Blockwise

`gb2}` - Toggle until the 2 next blank line
`gbaf` - Toggle comment around a function (w/ LSP/treesitter support)
`gbac` - Toggle comment around a class (w/ LSP/treesitter support)
```

## Notes

https://github.com/folke/todo-comments.nvim?tab=readme-ov-file#-usage

1. `:TodoTelescope` - Search through all project todos with Telescope
    1. `:TodoTelescope keywords=TODO,FIX`
2. `:TodoQuickFix` - This uses the quickfix list to show all todos in your project.


## NavBuddy

A simple popup display that provides breadcrumbs like navigation feature but in keyboard centric manner inspired by ranger file manager.

NB! Works inside a file.

`:NavBuddy`

commands:
`<leader>nb`

## TERMINAL

Open new terminal: `CTRL + T`

## GIT

### NEOGIT

Useful git utility that works inside vim.

commands: `<leader>g`

### DiffView

Docs: https://github.com/sindrets/diffview.nvim

**NB!** Not sure if needed if gitsigns is used.


### Gitsigns

Docs: https://github.com/lewis6991/gitsigns.nvim

## motion

### hop

Docs: https://github.com/smoka7/hop.nvim

NB! Doesn't set keybindings.

## AI assistant

When using `inline`

Keymaps:
`ga` = ACCEPT proposal
`gr` = REJECT proposal
