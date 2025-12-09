# Neovim commands (NVF)

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

## Diff

https://github.com/sindrets/diffview.nvim
