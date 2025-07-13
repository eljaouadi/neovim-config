-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>clr", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>inc", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>dec", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>swv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>swh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tb", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab


-- █ FUNCTION TO TOGGLE ARABIC RTL MODE
-- ─────────────────────────────────────
local function toggle_arabic_mode()
  if vim.opt.rightleft:get() then
    -- Turn OFF RTL mode
    vim.opt.rightleft = false
    vim.opt.relativenumber = true -- Restore relative numbers if you use them
    vim.notify("RTL Mode: OFF", vim.log.levels.INFO, { title = "Layout" })
  else
    -- Turn ON RTL mode
    vim.opt.rightleft = true
    vim.opt.relativenumber = false -- Relative numbers are confusing in RTL
    vim.notify("RTL Mode: ON", vim.log.levels.INFO, { title = "Layout" })
  end
end


keymap.set('n', '<F2>', toggle_arabic_mode, { noremap = true, silent = true, desc = "Toggle RTL layout for Arabic" })
