-- ~/AppData/Local/nvim/init.lua
-- Seamless Ctrl-h/j/k/l navigation across nvim splits <-> psmux panes.
-- Plugin-free: relies on psmux shipping a `tmux` command and setting $TMUX.

-- Make scoop's LLVM/clang available on PATH (no "clang"/"cc"/"gcc" otherwise —
-- needed by nvim-treesitter to compile parsers, e.g. for render-markdown.nvim).
do
  local llvm_bin = vim.fn.expand("~/scoop/apps/llvm/current/bin")
  if vim.fn.isdirectory(llvm_bin) == 1 and not vim.env.PATH:find(llvm_bin, 1, true) then
    vim.env.PATH = llvm_bin .. ";" .. vim.env.PATH
  end
  if vim.fn.executable("clang") == 1 then
    vim.env.CC = "clang"   -- the `cc` crate (used by tree-sitter build) needs CC set explicitly
  end
end

-- Make npm's global bin dir available on PATH (tree-sitter CLI lives there —
-- nvim-treesitter "main" branch needs it to build parsers).
do
  local npm_bin = vim.fn.expand("~/AppData/Roaming/npm")
  if vim.fn.isdirectory(npm_bin) == 1 and not vim.env.PATH:find(npm_bin, 1, true) then
    vim.env.PATH = npm_bin .. ";" .. vim.env.PATH
  end
end

-- Map nvim direction -> psmux select-pane flag
local psmux_dir = { h = "L", j = "D", k = "U", l = "R" }

local function navigate(dir)
  local before = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. dir)
  -- If the window didn't change, we're at an nvim edge -> ask psmux to move.
  if before == vim.api.nvim_get_current_win() and vim.env.TMUX then
    -- call psmux, NOT tmux: msys64 `tmux` targets a different/dead server
    vim.fn.system("psmux select-pane -" .. psmux_dir[dir])
  end
end

for key in pairs(psmux_dir) do
  vim.keymap.set("n", "<C-" .. key .. ">", function()
    navigate(key)
  end, { silent = true, desc = "Navigate split/psmux pane " .. key })
end

-- Minimal quality-of-life (remove if you have your own):
vim.opt.number = true
vim.opt.splitright = true   -- vsplit opens to the right (matches psmux `|`)
vim.opt.splitbelow = true   -- split opens below (matches psmux `-`)
vim.opt.clipboard = "unnamedplus"

-- =====================================================================
-- Ported from Dotfiles-and-scripts/dotfiles/vim/.vimrc
-- syntax/filetype-indent are on by default in Neovim -> not repeated.
-- =====================================================================

-- Options (from .vimrc)
vim.opt.relativenumber = true   -- :set rnu
vim.opt.tabstop = 4             -- set tabstop=4
vim.opt.shiftwidth = 4          -- set shiftwidth=4
vim.opt.expandtab = true        -- set expandtab
vim.opt.background = "dark"     -- set background=dark
vim.opt.foldmethod = "indent"   -- set foldmethod=indent
vim.opt.foldenable = false      -- set nofoldenable
vim.opt.foldnestmax = 1         -- set foldnestmax=1
-- NOTE: 'pastetoggle' (<F3>) removed upstream in Neovim; paste is auto-detected.

-- Ctrl-P (:Files) search: every text file, minus generated/vendored dirs and binaries.
local fzf_excludes = {
  ".git",
  "[Bb]uild", "[Oo]ut", "dist",
  "__pycache__", ".mypy_cache", ".pytest_cache", ".ruff_cache",
  ".venv", "venv",
  "node_modules",
  ".cache",
}
local fzf_binary_exts = {
  "o", "obj", "a", "lib", "so", "dll", "dylib",
  "exe", "elf", "hex", "bin", "s19", "srec", "mot",
  "pyc", "pyd", "class", "jar",
  "png", "jpg", "jpeg", "gif", "ico", "bmp", "pdf",
  "zip", "7z", "gz", "tar", "xz",
}
-- fd --exclude globs are case-sensitive and -i does not reach them, so each
-- letter becomes a two-case class: "o" -> "*.[oO]".
for _, ext in ipairs(fzf_binary_exts) do
  local glob = ext:gsub("%a", function(c) return "[" .. c:lower() .. c:upper() .. "]" end)
  table.insert(fzf_excludes, "*." .. glob)
end
local fzf_exclude_args = {}
for _, pat in ipairs(fzf_excludes) do
  table.insert(fzf_exclude_args, '--exclude "' .. pat .. '"')
end
vim.env.FZF_DEFAULT_COMMAND =
  "fd --type f --hidden " .. table.concat(fzf_exclude_args, " ")
vim.env.FZF_DEFAULT_OPTS = "-i"   -- always case-insensitive, even with uppercase in query

-- Keymaps (from .vimrc)
local map = vim.keymap.set
map("n", "<F2>", ":NERDTreeToggle<CR>", { desc = "Toggle NERDTree" })
map("n", "<C-e>", ":tabnext<CR>",     { silent = true, desc = "Next tab" })
map("n", "<C-q>", ":tabprevious<CR>", { silent = true, desc = "Prev tab" })
map("n", "<C-w>", ":tabclose<CR>",    { silent = true, desc = "Close tab" })
map("n", "<C-t>", ":tabnew<CR>",      { silent = true, desc = "New tab" })
map("n", "<Leader>f", ":Rg<CR>",   { silent = true, desc = "Ripgrep search" })
map("n", "<C-p>", ":Files<CR>",    { silent = true, desc = "fzf Files" })
map("n", "<Leader>gl", ":Git log --oneline --graph --all --decorate<CR>", { silent = true, desc = "Git log graph (fugitive)" })
map("i", "<C-c>", "<Esc>",         { desc = "Esc from insert" })

-- fzf.vim's :Maps is hardwired to normal mode (plugin/fzf.vim:77), so the other
-- modes go through fzf#vim#maps() directly.
map("n", "<Leader>?", ":Maps<CR>", { silent = true, desc = "Search keymaps (normal)" })
map("x", "<Leader>?", "<Cmd>call fzf#vim#maps('x')<CR>", { silent = true, desc = "Search keymaps (visual)" })
map("n", "<Leader>i?", "<Cmd>call fzf#vim#maps('i')<CR>", { silent = true, desc = "Search keymaps (insert)" })
map("n", "<Leader>o?", "<Cmd>call fzf#vim#maps('o')<CR>", { silent = true, desc = "Search keymaps (operator)" })
-- SKIPPED (Linux-only): `W` sudo-tee write, TurnOffCaps (xset/xdotool).

-- =====================================================================
-- Robot Framework filetype. polyglot claims filetype detection
-- (autoload/polyglot/init.vim:167 -> did_load_filetypes = 1) and its table
-- knows nothing about .robot/.resource, so those buffers end up with ft="".
-- This autocmd is registered after polyglot's ftdetect, so it wins.
-- =====================================================================
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.robot", "*.resource" },
  callback = function() vim.bo.filetype = "robot" end,
  desc = "Set ft=robot (polyglot's detection misses it)",
})

-- =====================================================================
-- Plugin manager: lazy.nvim (auto-bootstrap)
-- =====================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- language pack
  { "sheerun/vim-polyglot" },

  -- Robot Framework syntax (after/syntax/robot.vim). Neovim ships no
  -- syntax/robot.vim -- its robots.vim is robots.txt -- and polyglot has none
  -- either, so nothing highlights .robot without this plugin.
  -- The ft gate works only because of the vim.filetype.add below: polyglot
  -- sets did_load_filetypes=1 and its table has no robot entry, so an
  -- unpatched config leaves .robot buffers at ft="" and never triggers this.
  { "mfukar/robotframework-vim", ft = { "robot" } },

  -- tree, file, fuzzy find
  { "junegunn/fzf", build = function() vim.fn["fzf#install"]() end },
  { "junegunn/fzf.vim" },
  { "preservim/nerdtree" },           -- was scrooloose/nerdtree (moved)

  -- yazi file manager in a floating window
  {
    "mikavilpas/yazi.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { { "nvim-lua/plenary.nvim", lazy = true } },
    keys = {
      { "<Leader>-",  mode = { "n", "v" }, "<cmd>Yazi<cr>",        desc = "Yazi at current file" },
      { "<Leader>cw",                      "<cmd>Yazi cwd<cr>",    desc = "Yazi at nvim cwd" },
      { "<C-Up>",                          "<cmd>Yazi toggle<cr>", desc = "Resume last yazi session" },
    },
    opts = {
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
        -- <c-v>/<c-x> never reach nvim: Windows Terminal binds ctrl+v to
        -- Terminal.PasteFromClipboard (settings.json). Use Alt instead.
        open_file_in_vertical_split = "<M-v>",
        open_file_in_horizontal_split = "<M-x>",
      },
    },
  },

  -- git
  { "tpope/vim-fugitive" },
  { "airblade/vim-gitgutter" },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
      { "<Leader>gd", "<Cmd>DiffviewOpen<CR>",                 desc = "Diffview: working tree" },
      { "<Leader>gD", "<Cmd>DiffviewOpen main...HEAD<CR>",     desc = "Diffview: branch vs main" },
      { "<Leader>gh", "<Cmd>DiffviewFileHistory %<CR>",        desc = "Diffview: current file history" },
      { "<Leader>gH", "<Cmd>DiffviewFileHistory<CR>",          desc = "Diffview: repo history" },
      { "<Leader>gq", "<Cmd>DiffviewClose<CR>",                desc = "Diffview: close" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = { merge_tool = { layout = "diff3_mixed" } },
    },
  },

  -- color
  { "morhetz/gruvbox", priority = 1000 },

  -- surround
  { "tpope/vim-surround" },

  -- status bar
  { "vim-airline/vim-airline" },

  -- keymap popup. Reads each mapping's `desc`, so lazy.nvim's `keys=` entries
  -- show their description and not the shared lazy-load stub.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<Leader>c", group = "calls / comment" },
        { "<Leader>g", group = "git / diffview" },
        { "<Leader>h", group = "git hunks" },
      },
    },
  },

  -- unix commands (limited use on Windows; kept for parity)
  { "tpope/vim-eunuch" },

  -- comments
  { "preservim/nerdcommenter" },      -- was preservim/nerdcommenter

  -- markdown reading: in-buffer render (treesitter + render-markdown.nvim)
  -- plus glow.nvim for the floating-window / whole-file preview.
  -- "main" branch (not legacy "master") — master's query predicates crash on Neovim 0.12's treesitter API.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      -- Skip auto-install if parsers are already present (manually built —
      -- tree-sitter's own compiler auto-detection doesn't pick up clang here).
      local parser_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "parser")
      if vim.fn.filereadable(vim.fs.joinpath(parser_dir, "markdown.so")) == 0 then
        require("nvim-treesitter").install({ "markdown", "markdown_inline" })
      end
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function() pcall(vim.treesitter.start) end,
      })
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "markdown" },
    opts = {},
  },
  {
    "ellisonleao/glow.nvim",
    cmd = "Glow",
    ft = { "markdown" },
    opts = {},
  },

  -- terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = 15,
      open_mapping = [[<c-\>]],
      direction = "horizontal",
      shell = "pwsh",
    },
  },

  -- Completion: native LSP + nvim-cmp (replaces YouCompleteMe + vim-lsp)
  { "neovim/nvim-lspconfig" },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },
}, {
  install = { colorscheme = { "gruvbox" } },
})

-- =====================================================================
-- Colorscheme (was: autocmd vimenter * ++nested colorscheme gruvbox)
-- =====================================================================
-- airline globals must be set BEFORE colorscheme runs: airline hooks the
-- ColorScheme autocmd to run its one-time init, which reads these g: vars.
-- Setting them after was a no-op (init already ran and read the old values).
-- Bottom bar: no filename. Airline puts it in section_c (see airline/init.vim:273),
-- so blank that section out. section_b is left at its default (hunks + branch).
vim.g.airline_section_c = ""

vim.g["airline#extensions#tabline#enabled"] = 1   -- adds 2nd line
-- Show TABS, not buffers: buffers stay loaded after :q, so buffer mode keeps
-- listing closed files (tabline.vim:192 picks buffers when only 1 tab is open).
vim.g["airline#extensions#tabline#show_buffers"] = 0
vim.g["airline#extensions#tabline#show_tabs"] = 1

-- Top bar RIGHT side (tabs.vim:95 -> get_buffer_name -> default formatter):
-- full absolute path, unabbreviated. Default was ':~:.' + pathshorten().
vim.g["airline#extensions#tabline#fnamemod"] = ":p"
vim.g["airline#extensions#tabline#fnamecollapse"] = 0

-- Top bar TAB LABELS: filename only, no path. title() consults
-- tabtitle_formatter first (tabline.vim:209) and only falls back to the
-- shared buffer-name formatter, so this splits the two displays apart.
vim.cmd([[
  function! AirlineTabTitleFilename(n) abort
    let buflist = tabpagebuflist(a:n)
    let name = bufname(buflist[tabpagewinnr(a:n) - 1])
    return empty(name) ? '[No Name]' : fnamemodify(name, ':t')
  endfunction
]])
vim.g["airline#extensions#tabline#tabtitle_formatter"] = "AirlineTabTitleFilename"
vim.opt.showtabline = 2   -- force tabline visible even with 1 buffer
vim.opt.laststatus = 2    -- force statusline visible even with 1 window

-- gruvbox is a truecolor scheme: without termguicolors its guifg/guibg are
-- ignored and nvim uses cterm fallbacks, where airline_tabfill ends up
-- ctermfg=235 ctermbg=235 (fg==bg) -> tabline renders invisible against bg.
vim.opt.termguicolors = true
vim.g.airline_theme = "gruvbox"   -- match airline palette to the colorscheme

pcall(vim.cmd.colorscheme, "gruvbox")

-- =====================================================================
-- Completion: nvim-cmp
-- =====================================================================
local ok_cmp, cmp = pcall(require, "cmp")
if ok_cmp then
  local luasnip = require("luasnip")
  cmp.setup({
    snippet = {
      expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<Tab>"] = cmp.mapping.select_next_item(),
      ["<S-Tab>"] = cmp.mapping.select_prev_item(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<C-Space>"] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
    }),
  })
end

-- =====================================================================
-- LSP: native (Neovim 0.11+ vim.lsp.config/enable). clangd for C/C++
-- (the .vimrc targeted PlatformIO C/C++ via vim-lsp). Enabled only if
-- the server binary is on PATH.
-- =====================================================================
local ok_caps, cmp_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = ok_caps and cmp_lsp.default_capabilities() or nil
if capabilities then
  vim.lsp.config("*", { capabilities = capabilities })
end
local clangd_cmd = "clangd"
if vim.fn.executable("clangd") ~= 1 then
  local fallback = vim.fn.expand("~/scoop/apps/llvm/current/bin/clangd.exe")
  if vim.fn.filereadable(fallback) == 1 then
    clangd_cmd = fallback
  end
end
if vim.fn.executable(clangd_cmd) == 1 or vim.fn.filereadable(clangd_cmd) == 1 then
  vim.lsp.config("clangd", { cmd = { clangd_cmd } })
  vim.lsp.enable("clangd")
end

-- Call hierarchy entries carry the caller's name but the call site's position, so
-- the cursor lands inside the caller, not on its name. Walk documentSymbol to the
-- innermost enclosing function and query from its name instead.
local function calls_of_enclosing(fn)
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/documentSymbol" })
  if not next(clients) then
    vim.notify("No documentSymbol client", vim.log.levels.WARN)
    return
  end
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  clients[1]:request("textDocument/documentSymbol",
    { textDocument = vim.lsp.util.make_text_document_params(bufnr) },
    function(err, result)
      if err or not result then
        vim.notify("documentSymbol failed", vim.log.levels.WARN)
        return
      end
      local found
      local function walk(syms)
        for _, sym in ipairs(syms or {}) do
          local r = sym.range
          if r and r.start.line <= row and row <= r["end"].line then
            -- 12 = Function, 6 = Method
            if sym.kind == 12 or sym.kind == 6 then found = sym end
            walk(sym.children)
          end
        end
      end
      walk(result)
      if not found then
        vim.notify("No enclosing function", vim.log.levels.WARN)
        return
      end
      local pos = found.selectionRange.start
      vim.api.nvim_win_set_cursor(0, { pos.line + 1, pos.character })
      fn()
    end)
end

-- Jump-def + call hierarchy keymaps (active only in buffers w/ LSP attached)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
    vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
    vim.keymap.set("n", "<Leader>ci", vim.lsp.buf.incoming_calls, vim.tbl_extend("force", opts, { desc = "Incoming calls" }))
    vim.keymap.set("n", "<Leader>co", vim.lsp.buf.outgoing_calls, vim.tbl_extend("force", opts, { desc = "Outgoing calls" }))
    vim.keymap.set("n", "<Leader>cu", function() calls_of_enclosing(vim.lsp.buf.incoming_calls) end,
      vim.tbl_extend("force", opts, { desc = "Incoming calls of enclosing function" }))
    vim.keymap.set("n", "<Leader>cU", function() calls_of_enclosing(vim.lsp.buf.outgoing_calls) end,
      vim.tbl_extend("force", opts, { desc = "Outgoing calls of enclosing function" }))
  end,
})

-- Each incoming/outgoing_calls run pushes a new quickfix list, so the quickfix
-- history is the call-hierarchy stack: older = one level back toward the caller.
vim.keymap.set("n", "<Leader>ck", "<Cmd>colder<CR>", { silent = true, desc = "Call hierarchy: level back" })
vim.keymap.set("n", "<Leader>cj", "<Cmd>cnewer<CR>", { silent = true, desc = "Call hierarchy: level forward" })

-- =====================================================================
-- fugitive :G status window: `dg` = open file under cursor (staged or
-- not) and show it as a GitGutterDiffOrig split (working tree vs index).
-- Reuses fugitive's own <CR> open, then waits for gitgutter to resolve the
-- buffer's repo path before diffing. `<CR>` keeps its plain-open behavior.
--
-- Why the wait: gitgutter resolves a buffer's repo path with an async
-- `git ls-files` and parks a sentinel meanwhile -- -1 pending, -2 untracked,
-- -3 assume-unchanged (gitgutter/utility.vim:158-162). GitGutterDiffOrig
-- concatenates that value straight into `git show <base>:<path>` with no
-- validation (gitgutter.vim:269), so firing it in the same tick as the open
-- gives `fatal: ambiguous argument ':-1'`. Only showed up on some files
-- because it's a race: big repos and first-visit buffers lose it.
-- =====================================================================
vim.api.nvim_create_autocmd("FileType", {
  pattern = "fugitive",
  callback = function()
    vim.keymap.set("n", "dg", function()
      -- "x" flushes the typeahead now, so the file buffer exists on return.
      local keys = vim.api.nvim_replace_termcodes("<CR>:only<CR>", true, false, true)
      vim.api.nvim_feedkeys(keys, "mx", false)

      local bufnr = vim.api.nvim_get_current_buf()
      local function diff_when_ready(tries)
        -- A resolved path is a non-empty string; every sentinel is a number.
        local p = vim.fn["gitgutter#utility#repo_path"](bufnr, 0)
        if type(p) == "string" and p ~= "" then
          vim.cmd("GitGutterDiffOrig")
        elseif p == -2 then
          vim.notify("dg: file not tracked by git", vim.log.levels.WARN)
        elseif p == -3 then
          vim.notify("dg: file is assume-unchanged", vim.log.levels.WARN)
        elseif tries >= 100 then   -- 100 * 50ms = 5s
          vim.notify("dg: gitgutter never resolved a repo path", vim.log.levels.WARN)
        else
          vim.defer_fn(function() diff_when_ready(tries + 1) end, 50)
        end
      end
      diff_when_ready(0)
    end, { buffer = true, silent = true, desc = "Open file + GitGutterDiffOrig" })
  end,
})
