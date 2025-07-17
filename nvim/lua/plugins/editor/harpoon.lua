return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    opts = {
      settings = {
        save_on_toggle = true,
      },
    },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup {}

      -- Telescope configuration
      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local make_finder = function()
          local file_paths = {}
          for _, item in ipairs(harpoon_files.items) do
            table.insert(file_paths, item.value)
          end
          return require('telescope.finders').new_table {
            results = file_paths,
          }
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = make_finder(),
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
            attach_mappings = function(prompt_bufnr, map)
              local harpoon_remove = function()
                local state = require 'telescope.actions.state'
                local selected_entry = state.get_selected_entry()
                local current_picker = state.get_current_picker(prompt_bufnr)
                table.remove(harpoon_files.items, selected_entry.index)
                current_picker:refresh(make_finder())
              end

              -- Set keymap for removing file from Harpoon
              map('i', '<C-w>', harpoon_remove)
              return true
            end,
          })
          :find()
      end

      -- Set keymap for listing files in Telescope
      vim.keymap.set('n', '<leader>hl', function()
        toggle_telescope(harpoon:list())
      end, { desc = '[L]ist Files' })
    end,
    keys = function()
      local mappings = {
        {
          '<leader>ha',
          function()
            require('harpoon'):list():add()
          end,
          desc = '[A]dd File',
        },
        {
          '<leader>hp',
          function()
            require('harpoon'):list():prev()
          end,
          desc = '[P]revious File',
        },
        {
          '<leader>hn',
          function()
            require('harpoon'):list():next()
          end,
          desc = '[N]ext File',
        },
      }

      -- Add mappings for selecting files with index
      for index = 1, 4 do
        table.insert(mappings, {
          '<leader>h' .. index,
          function()
            require('harpoon'):list():select(index)
          end,
          desc = 'File [' .. index .. ']',
        })
      end
      return mappings
    end,
  },
}
