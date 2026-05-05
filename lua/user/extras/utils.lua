return {


    {
        "RRethy/vim-illuminate",
        config = function()
            require("illuminate").configure({ delay = 200 })
        end
    },

    { "tpope/vim-sleuth" },

    -- The gold standard for Git
    { "tpope/vim-fugitive" },
}
