return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		require("mini.pairs").setup()
		require("mini.surround").setup()
		require("mini.comment").setup()
		require("mini.move").setup()
		require("mini.splitjoin").setup()
		require("mini.jump2d").setup()
		require("mini.animate").setup()
		--require("mini.notify").setup()
	end,
}
