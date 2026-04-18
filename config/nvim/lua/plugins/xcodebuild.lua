return {
  "wojciech-kulik/xcodebuild.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("xcodebuild").setup({
      integrations = {
        picker = "fzf-lua",
      },
      code_coverage = {
        enabled = false,
      },
    })

    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { desc = desc })
    end

    map("<leader>xp", "<cmd>XcodebuildPicker<cr>",              "Xcode: all actions")
    map("<leader>xb", "<cmd>XcodebuildBuild<cr>",               "Xcode: build")
    map("<leader>xr", "<cmd>XcodebuildBuildRun<cr>",            "Xcode: build & run")
    map("<leader>xt", "<cmd>XcodebuildTest<cr>",                "Xcode: run tests")
    map("<leader>xT", "<cmd>XcodebuildTestClass<cr>",           "Xcode: test current class")
    map("<leader>xs", "<cmd>XcodebuildSelectScheme<cr>",        "Xcode: select scheme")
    map("<leader>xd", "<cmd>XcodebuildSelectDevice<cr>",        "Xcode: select device")
    map("<leader>xc", "<cmd>XcodebuildToggleCodeCoverage<cr>",  "Xcode: toggle coverage")
    map("<leader>xl", "<cmd>XcodebuildToggleLogs<cr>",          "Xcode: toggle logs")
  end,
}
