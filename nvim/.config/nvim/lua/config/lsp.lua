require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

require("mason-lspconfig").setup({
	-- A list of servers to automatically install if they're not already installed
	ensure_installed = {},
})

-- Set different settings for different languages' LSP
-- LSP list: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- How to use setup({}): https://github.com/neovim/nvim-lspconfig/wiki/Understanding-setup-%7B%7D
--     - the settings table is sent to the LSP
--     - on_attach: a lua callback function to run after LSP attaches to a given buffer
local lspconfig = require("lspconfig")
local null_ls = require("null-ls")

-- Customized on_attach function
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set(
	"n",
	"<space>xf",
	vim.diagnostic.open_float,
	vim.tbl_extend("force", opts, { desc = "Open Diagnostic Float" })
)
vim.keymap.set(
	"n",
	"[d",
	vim.diagnostic.goto_prev,
	vim.tbl_extend("force", opts, { desc = "Go to Previous Diagnostic" })
)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Go to Next Diagnostic" }))
vim.keymap.set(
	"n",
	"<space>xs",
	vim.diagnostic.setloclist,
	vim.tbl_extend("force", opts, { desc = "Set Diagnostic Location List" })
)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set(
		"n",
		"<space>cgc",
		vim.lsp.buf.declaration,
		vim.tbl_extend("force", bufopts, { desc = "Go to Declaration" })
	)
	vim.keymap.set(
		"n",
		"<space>cgf",
		vim.lsp.buf.definition,
		vim.tbl_extend("force", bufopts, { desc = "Go to Definition" })
	)
	vim.keymap.set("n", "<space>ch", vim.lsp.buf.hover, vim.tbl_extend("force", bufopts, { desc = "Show Hover" }))
	vim.keymap.set(
		"n",
		"<space>cgi",
		vim.lsp.buf.implementation,
		vim.tbl_extend("force", bufopts, { desc = "Go to Implementation" })
	)
	vim.keymap.set(
		"n",
		"<space>cs",
		vim.lsp.buf.signature_help,
		vim.tbl_extend("force", bufopts, { desc = "Show Signature Help" })
	)
	vim.keymap.set(
		"n",
		"<space>cwa",
		vim.lsp.buf.add_workspace_folder,
		vim.tbl_extend("force", bufopts, { desc = "Add Workspace Folder" })
	)
	vim.keymap.set(
		"n",
		"<space>cwr",
		vim.lsp.buf.remove_workspace_folder,
		vim.tbl_extend("force", bufopts, { desc = "Remove Workspace Folder" })
	)
	vim.keymap.set("n", "<space>cwl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, vim.tbl_extend("force", bufopts, { desc = "List Workspace Folders" }))
	vim.keymap.set(
		"n",
		"<space>cgt",
		vim.lsp.buf.type_definition,
		vim.tbl_extend("force", bufopts, { desc = "Go to Type Definition" })
	)
	vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, vim.tbl_extend("force", bufopts, { desc = "Rename Symbol" }))
	vim.keymap.set(
		"n",
		"<space>ca",
		vim.lsp.buf.code_action,
		vim.tbl_extend("force", bufopts, { desc = "Code Actions" })
	)
	vim.keymap.set(
		"n",
		"<space>cgr",
		vim.lsp.buf.references,
		vim.tbl_extend("force", bufopts, { desc = "Go to References" })
	)
	-- vim.keymap.set("n", "<space>cf", function()
	--     vim.lsp.buf.format({ async = true })
	-- end, vim.tbl_extend('force', bufopts, { desc = "Format Buffer" }))
end
-- Configure each language
-- How to add LSP for a specific language?
-- 1. use `:Mason` to install corresponding LSP
-- 2. add configuration below
lspconfig.lua_ls.setup({
	on_attach = on_attach,
})

lspconfig.pyright.setup({
	on_attach = on_attach,
})

lspconfig.djlsp.setup({
	on_attach = on_attach,
})

lspconfig.dockerls.setup({
	on_attach = on_attach,
})

lspconfig.docker_compose_language_service.setup({
	on_attach = on_attach, -- Use your existing on_attach function
	cmd = { "docker-compose-langserver", "--stdio" }, -- Command to start the LSP
	filetypes = { "yaml" }, -- Attach to YAML files
	root_dir = lspconfig.util.root_pattern("docker-compose.yml"), -- Look for docker-compose.yml in the root directory
})

null_ls.setup({
	sources = {
		null_ls.builtins.diagnostics.flake8.with({
			extra_args = { "--max-line-length=88" }, -- Specify line length
		}),
		null_ls.builtins.diagnostics.djlint,
		null_ls.builtins.diagnostics.hadolint,
	},
})
