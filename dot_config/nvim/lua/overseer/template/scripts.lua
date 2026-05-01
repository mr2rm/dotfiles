---@type overseer.TemplateFileProvider
return {
  generator = function()
    local root = vim.fn.getcwd()
    local scripts_dir = vim.fs.joinpath(root, 'scripts')
    if vim.fn.isdirectory(scripts_dir) ~= 1 then
      return {}
    end

    local templates = {}
    for name, type_ in vim.fs.dir(scripts_dir) do
      if type_ == 'file' then
        local script = vim.fs.joinpath(scripts_dir, name)
        if name:match '%.sh$' and vim.fn.executable(script) == 1 then
          table.insert(templates, {
            name = name,
            desc = 'scripts/' .. name,
            tags = { 'script' },
            builder = function()
              return {
                name = name,
                cwd = root,
                cmd = { script },
                components = { 'default' },
              }
            end,
          })
        end
      end
    end

    return templates
  end,

  cache_key = function()
    local root = vim.fn.getcwd()
    return vim.fs.joinpath(root, 'scripts')
  end,
}
