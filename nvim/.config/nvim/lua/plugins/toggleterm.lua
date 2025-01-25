return {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    version = "*",
    opts = {
        size = function(term)
            if term.direction == "horizontal" then
                return 15
            elseif term.direction == "vertical" then
                return vim.opt.columns * 0.4
            end
        end,
        open_mapping = "<c-\\>",
        hide_numbers = true,
        start_in_insert = true,
        insert_mappings = true,
        auto_scroll = true,
    },
}
