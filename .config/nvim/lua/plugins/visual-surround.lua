return {

{
    "NStefan002/visual-surround.nvim",
    config = function()
        require("visual-surround").setup(
            {
             -- if set to true, the user must manually add keymaps
             use_default_keymaps = true,
             -- will be ignored if use_default_keymaps is set to false
             surround_chars = { "{", "}", "[", "]", "(", ")", "'", '"', "`" },
             -- whether to exit visual mode after adding surround
             exit_visual_mode = true,
        })
    end,
    -- or if you don't want to change defaults
    -- config = true
}

}
