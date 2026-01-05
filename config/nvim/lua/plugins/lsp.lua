return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    'neovim/nvim-lspconfig',

    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },

    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction')
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        end,
      })

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local servers = {
        clangd = {
          cmd = {
            'clangd',
            '--background-index', -- Index project in background (fast search)
            '--clang-tidy', -- Enable static analysis (linting)
            '--header-insertion=iwyu', -- "Include What You Use" logic for auto-imports
            '--completion-style=detailed',
            '--function-arg-placeholders',
            '--fallback-style=llvm',
            -- CRITICAL FOR MAC: Tells clangd where to find system headers
            '--query-driver=/usr/bin/clang++,/opt/homebrew/bin/g++',
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
        pyright = {},
        -- EXPLICIT RUFF CONFIG TO PREVENT CRASHES
        ruff = {
          cmd = { 'ruff', 'server' },
          filetypes = { 'python' },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
            },
          },
        },
      }

      require('mason').setup()

      -- Removed 'ruff' from ensure_installed to avoid Mason errors (use brew/pip/system ruff)
      local ensure_installed = vim.tbl_keys(servers or {})

      -- 2. Add tools that aren't LSPs (like formatters)
      vim.list_extend(ensure_installed, { 'stylua' })

      -- 3. MANUALLY REMOVE RUFF
      -- We filter the list to ensure 'ruff' is NOT passed to Mason
      ensure_installed = vim.tbl_filter(function(name)
        return name ~= 'ruff'
      end, ensure_installed)

      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      -- 1. Setup Ruff (Native)
      if servers.ruff then
        vim.api.nvim_create_autocmd('FileType', {
          pattern = 'python',
          callback = function(ev)
            vim.lsp.start {
              name = 'ruff',
              cmd = servers.ruff.cmd,
              -- Find root based on git or pyproject
              root_dir = vim.fs.root(ev.buf, { 'pyproject.toml', 'ruff.toml', '.git' }),
              capabilities = capabilities,
            }
          end,
        })
      end
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles Pyright automatically because it's in the 'servers' table
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }

      -- 2. Setup Clangd (Native)
    end,
  },
}
