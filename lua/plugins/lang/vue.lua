-- Vue support is handled via:
--   1. volar LSP (hybrid mode) — configured in plugins/lsp.lua
--   2. typescript-tools.nvim with @vue/typescript-plugin — configured in plugins/lang/typescript.lua
--   3. Treesitter vue parser — configured in plugins/treesitter.lua
--   4. nvim-ts-autotag — configured in plugins/coding.lua
--
-- Hybrid mode (volar.server.hybridMode = true) means volar handles
-- template/style intellisense while typescript-tools handles the TS side.
-- No additional plugin is required here.
return {}
