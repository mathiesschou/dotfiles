-- Bootstrap lazy.nvim (installs itself on first launch) and load plugin specs.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Any *.lua file you drop in lua/plugins/ becomes a plugin spec.
-- The folder is empty for now — add your own packages there.
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  checker = { enabled = true }, -- check for plugin updates
})
