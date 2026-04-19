-- [
-- AUTHOR: Evelyn (Plum) Hill
-- DATE: April 06, 2026
-- ]
--
--
-- This config was started from the neovim default config provided by
-- nvim 0.12.0. It is as modern as I can manage.
-- I don't require much so It's hypr small.
--
--
-- Set <space> as the leader key
-- See `:h mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "

-- OPTIONS
--
-- See `:h vim.o`
-- NOTE: You can change these options as you wish!
-- For more options, you can see `:h option-list`
-- To see documentation for an option, you can use `:h 'optionname'`, for example `:h 'number'`
-- (Note the single quotes)

vim.o.number = true -- Show line numbers in a column.

-- Show line numbers relative to where the cursor is.
-- Affects the 'number' option above, see `:h number_relativenumber`.
vim.o.relativenumber = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2

-- Sync clipboard between OS and Neovim. Schedule the setting after `UIEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:h 'clipboard'`
vim.api.nvim_create_autocmd("UIEnter", {
	callback = function()
		vim.o.clipboard = "unnamedplus"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "svelte",
	callback = function(ev)
		vim.treesitter.start(ev.buf, "svelte")
	end,
})

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.cursorline = true -- Highlight the line where the cursor is on.
vim.o.scrolloff = 10 -- Keep this many screen lines above/below the cursor.
vim.o.list = false -- Show <tab> and trailing spaces.

-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s). See `:h 'confirm'`
vim.o.confirm = true

vim.opt.termguicolors = true

vim.opt.wrap = false

-- AUTOCOMMANDS (EVENT HANDLERS)
--
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(event)
		if event.data.updated then
			require("fff.download").download_or_build_binary()
		end
	end,
})

-- USER COMMANDS: DEFINE CUSTOM COMMANDS
--
-- See `:h nvim_create_user_command()` and `:h user-commands`

-- Create a command `:GitBlameLine` that print the git blame for the current line
vim.api.nvim_create_user_command("GitBlameLine", function()
	local line_number = vim.fn.line(".") -- Get the current line number. See `:h line()`
	local filename = vim.api.nvim_buf_get_name(0)
	print(vim.system({ "git", "blame", "-L", line_number .. ",+1", filename }):wait().stdout)
end, { desc = "Print the git blame for the current line" })

-- PLUGINS
--
-- See `:h :packadd`, `:h vim.pack`

-- Add the "nohlsearch" package to automatically disable search highlighting after
-- 'updatetime' and when going to insert mode.
vim.cmd("packadd! nohlsearch")

-- Install third-party plugins via "vim.pack.add()".
vim.pack.add({
	-- Quickstart configs for LSP 'https://github.com/neovim/nvim-lspconfig',

	-- Treesitter
	"https://github.com/nvim-treesitter/nvim-treesitter",

	-- Mini stuff
	"https://github.com/echasnovski/mini.icons",
	"https://github.com/echasnovski/mini.snippets",

	-- Autocomplete
	"https://github.com/hrsh7th/cmp-nvim-lsp",
	"https://github.com/hrsh7th/cmp-buffer",
	"https://github.com/hrsh7th/cmp-path",
	"https://github.com/hrsh7th/cmp-cmdline",
	"https://github.com/hrsh7th/nvim-cmp",
	"https://github.com/abeldekat/cmp-mini-snippets",

	-- Enhanced quickfix/loclist
	"https://github.com/stevearc/quicker.nvim",

	-- Git integration
	"https://github.com/lewis6991/gitsigns.nvim",

	-- Fuzzy Finder
	"https://github.com/dmtrKovalenko/fff.nvim",

	-- Colors
	"https://github.com/ankushbhagats/pastel.nvim",
	"https://github.com/vague-theme/vague.nvim",

	-- LSP
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/mason-org/mason-lspconfig.nvim",

	-- Lua Line
	"https://github.com/nvim-lualine/lualine.nvim",

	-- Toggle term bc it rules
	"https://github.com/akinsho/toggleterm.nvim",

	-- HTML tag auto-close
	"https://github.com/windwp/nvim-ts-autotag",

	-- Formatting
	"https://github.com/stevearc/conform.nvim",

	-- Todo comments
	"https://github.com/folke/todo-comments.nvim",

	-- Glance for peeking at definitions
	"https://github.com/DNLHC/glance.nvim",

	-- splash screen
	"https://github.com/goolord/alpha-nvim",

	-- oil (buffer like file exploration)
	"https://github.com/stevearc/oil.nvim",
})

-- SETUP PLUGINS --

-- Only show errors inline.
vim.diagnostic.config({
	virtual_text = {
		severity = { min = vim.diagnostic.severity.ERROR },
	},
})

require("mini.icons").setup({})
require("mini.snippets").setup({
	snippets = {
		require("mini.snippets").gen_loader.from_lang(), -- loads friendly-snippets per filetype
	},
})
require("quicker").setup({})
require("gitsigns").setup({})

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "rust_analyzer" },
})

require("lualine").setup({})

require("pastel").setup({
	style = {
		transparent = "*",
		inactive = false,
	},
	palette = "pastelpop",
})

require("vague").setup({
	transparent = true,
})

require("nvim-treesitter").setup({})

require("nvim-treesitter.config").setup({
	ensure_installed = { "typescript", "css", "javascript", "svelte" },
	highlight = { enable = true },
})

-- Override default (imo non sensible) settings with blank config.
require("nvim-ts-autotag").setup({})

require("conform").setup({
	formatters_by_ft = {
		html = { "prettier" },
	},
	format_on_save = { timeout_ms = 500, lsp_fallback = true },
})

require("todo-comments").setup({})

require("glance").setup({
	border = {
		enable = true,
		top_char = "―",
		bottom_char = "―",
	},
})

require("alpha").setup(require("alpha.themes.dashboard").config)

require("oil").setup({
	default_file_explorer = true,
})

-- Set the default formatter to conform.
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
			insert({ body = args.body })
			cmp.resubscribe({ "TextChangedI", "TextChangedP" })
			require("cmp.config").set_onetime({ sources = {} })
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<C-e>"] = cmp.mapping.abort(),
		["<C-Space>"] = cmp.mapping.complete(),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "mini_snippets" },
		{ name = "buffer" },
		{ name = "path" },
	}),
})

vim.g.fff = {
	lazy_sync = true, -- start syncing only when the picker is open
	debug = {
		enabled = true,
		show_scores = true,
	},
}

-- local ok, treesitter = pcall(require, "nvim-treesitter.configs")
-- if ok then
--   treesitter.setup({
--     ensure_installed = { "typescript", "css", "javascript", "svelte" },
--     highlight = { enable = true },
--   })
-- else
--   vim.notify("nvim-treesitter not loaded: " .. treesitter, vim.log.levels.WARN)
-- end

vim.filetype.add({
	extension = {
		svelte = "svelte",
	},
})

require("toggleterm").setup({
	direction = "vertical",
	size = 60,
})

vim.keymap.set({ "n", "t" }, "<leader>fk", "<cmd>ToggleTerm<cr>")

-- KEYMAPS
--
-- See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

-- Fuzzyfind
vim.keymap.set("n", "<leader>fj", function()
	require("fff").find_files()
end, { desc = "FFFind files" })

-- show diagnostic/lsp hints.
vim.keymap.set("n", "<leader>sd", function()
	vim.diagnostic.open_float(nil, {
		focusable = true,
		scope = "line",
	})
end, { desc = "Show Diagnostic" })

-- Exit current buffer to netrw.
vim.keymap.set("n", "<leader>ef", function()
	require("oil").open()
end, { desc = "Return to file browser" })

-- Use <Esc> to exit terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
vim.keymap.set({ "t", "i" }, "<A-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set({ "t", "i" }, "<A-j>", "<C-\\><C-n><C-w>j")
vim.keymap.set({ "t", "i" }, "<A-k>", "<C-\\><C-n><C-w>k")
vim.keymap.set({ "t", "i" }, "<A-l>", "<C-\\><C-n><C-w>l")
vim.keymap.set({ "n" }, "<A-h>", "<C-w>h")
vim.keymap.set({ "n" }, "<A-j>", "<C-w>j")
vim.keymap.set({ "n" }, "<A-k>", "<C-w>k")
vim.keymap.set({ "n" }, "<A-l>", "<C-w>l")

function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<C-w>h", [[<C-\><C-n><C-w>h]], opts)
	vim.keymap.set("t", "<C-w>j", [[<C-\><C-n><C-w>j]], opts)
	vim.keymap.set("t", "<C-w>k", [[<C-\><C-n><C-w>k]], opts)
	vim.keymap.set("t", "<C-w>l", [[<C-\><C-n><C-w>l]], opts)
end

vim.cmd("autocmd! TermOpen term://*toggleterm* lua set_terminal_keymaps()")

vim.keymap.set("n", "<leader>ld", "<CMD>Glance definitions<CR>")
vim.keymap.set("n", "<leader>lr", "<CMD>Glance references<CR>")
vim.keymap.set("n", "<leader>ly", "<CMD>Glance type_definitions<CR>")
vim.keymap.set("n", "<leader>lm", "<CMD>Glance implementations<CR>")

vim.cmd.colorscheme("pastel")
