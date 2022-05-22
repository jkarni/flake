local status, project = pcall(require, "project_nvim")
if not status then
  vim.notify("Project Not Found")
  return
end

-- nvim-tree 支持
vim.g.nvim_tree_respect_buf_cwd = 1

project.setup({
  detection_methods = { "pattern" },
  patterns = { ".git", "Makefile", "package.json", "Cargo.toml", "README", "README.md" },
})