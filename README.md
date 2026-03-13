# scratch.nvim

Every once in a while I catch myself needing to store some junk lines of code while I'm busy setting up a git commit or
reorganizing a piece of code. Eventually, I decided enough is enough, so I created this tiny plugin to give disposable
lines a place to call home: the **scratch** buffer.

Features:

- Toggle the scratch buffer window
- Auto save changes to the scratch buffer so that it persists throughout multiple vim sessions
- Sane defaults with *light* configuration options

Non features:

- Persistent, directory-based scratch buffers - just save the poor file :)

## Installation

As it's the norm with Neovim plugins, `scratch.nvim` is initialized via calling the `require("scratch").setup` function
that takes an *optional* table of configuration options. Defaults:

```lua
{
  -- Auto-saves scratch buffer when change focus/hide the buffer. Ignored if filepath is "".
  autosave = true,
  -- Absolute path where to save the persistent buffer. Can be set to "" to use non-persistent scratch buffers.
  filepath = vim.fn.stdpath("data") .. "/scratch.txt",
  -- Opener function used to create scratch window. Takes a bufnr and spawns a windows displaying the scratch
  -- buffer. Some preset openers are available at require('scratch.openers'), but you can also pass a custom
  -- function that suits your needs.
  opener = require('scratch.openers').float,
}
```

Available opener presets are:

* `require('scratch.openers').float` (default): a float that covers 80% of visible editor screen;
* `require('scratch.openers').split`: horizontal split with a height of 10 lines;
* `require('scratch.openers').vsplit`: right vertical split;

### [lazy.nvim](https://github.com/folke/lazy.nvim)

Basic setup with default options:

```lua
{ "DanielCardeal/scratch.nvim", opts = {} }
```

More advanced setup with lazy loading and customer opener function:

```lua
{
  "DanielCardeal/scratch.nvim",
  keys = {
    {
      "<leader>x",
      "<cmd>ScratchToggle<cr>",
      desc = "Toggle scratch",
    },
  },
  config = function()
    require("scratch").setup({
      opener = function(bufnr)
        vim.api.nvim_open_win(bufnr, true, { split = "right", win = 0, })
      end,
    })
  end,
}
```

# Acknowledgments 

- [Doom Emacs](https://github.com/doomemacs/doomemacs) for showing me the usefulness of a scratch buffer.
