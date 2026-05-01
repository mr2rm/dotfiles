--- Creates a template for running a uv task.
---@param name string Task name.
---@param root string Project root.
---@param cmd string[] Command to run.
---@return overseer.TemplateFileDefinition
local function create_uv_template(name, root, cmd)
  return {
    name = name,
    tags = { 'uv' },
    builder = function()
      return {
        name = name,
        cwd = root,
        cmd = cmd,
        components = { 'default' },
      }
    end,
  }
end

---@type overseer.TemplateFileProvider
return {
  generator = function()
    local root = vim.fn.getcwd()
    local uv_lock = vim.fs.joinpath(root, 'uv.lock')
    if vim.uv.fs_stat(uv_lock) == nil then
      return {}
    end

    return {
      create_uv_template('uv sync', root, { 'uv', 'sync' }),
      create_uv_template('uv lock', root, { 'uv', 'lock' }),
      create_uv_template('uv upgrade', root, { 'uv', 'lock', '--upgrade' }),
    }
  end,

  cache_key = function()
    local root = vim.fn.getcwd()
    return vim.fs.joinpath(root, 'uv.lock')
  end,
}
