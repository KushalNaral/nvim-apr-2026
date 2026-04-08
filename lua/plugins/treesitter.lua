return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    branch = 'main',
    config = function()
      local parsers = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        -- Rust
        'rust',
        'ron',
        'toml',
        -- Go
        'go',
        'gomod',
        'gosum',
        'gowork',
        -- JS/TS ecosystem
        'javascript',
        'typescript',
        'tsx',
        'jsdoc',
        -- Vue / CSS
        'vue',
        'css',
        'scss',
        -- PHP (blade parser requires custom registration; skip for now)
        'php',
        'phpdoc',
        -- Data / config
        'json',
        'yaml',
        -- Infra / misc
        'dockerfile',
        'gitcommit',
        'gitignore',
        'regex',
        'sql',
        -- GraphQL / Prisma
        'prisma',
        'graphql',
      }
      require('nvim-treesitter').install(parsers)

      ---@param buf integer
      ---@param language string
      local function treesitter_try_attach(buf, language)
        if not vim.treesitter.language.add(language) then return end
        vim.treesitter.start(buf, language)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      local available_parsers = require('nvim-treesitter').get_available()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local buf, filetype = args.buf, args.match
          local language = vim.treesitter.language.get_lang(filetype)
          if not language then return end
          local installed_parsers = require('nvim-treesitter').get_installed 'parsers'
          if vim.tbl_contains(installed_parsers, language) then
            treesitter_try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
          else
            treesitter_try_attach(buf, language)
          end
        end,
      })
    end,
  },

  -- Textobjects (main branch to match treesitter main)
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    lazy = true,
  },
}
