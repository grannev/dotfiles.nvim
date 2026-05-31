local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit window" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Horizontal split" })

map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bl", "<cmd>ls<CR>", { desc = "List buffers" })

map("n", "<A-Left>", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "<A-Right>", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<A-S-Left>", "<cmd>tabmove -1<CR>", { desc = "Move tab left" })
map("n", "<A-S-Right>", "<cmd>tabmove +1<CR>", { desc = "Move tab right" })
map("n", "\27[1;4D", "<cmd>tabmove -1<CR>", { desc = "Move tab left" })
map("n", "\27[1;4C", "<cmd>tabmove +1<CR>", { desc = "Move tab right" })

map("n", "<leader>tt", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<leader>to", "<cmd>tabonly<CR>", { desc = "Only current tab" })

map("n", "<A-1>", "1gt", { desc = "Tab 1" })
map("n", "<A-2>", "2gt", { desc = "Tab 2" })
map("n", "<A-3>", "3gt", { desc = "Tab 3" })
map("n", "<A-4>", "4gt", { desc = "Tab 4" })
map("n", "<A-5>", "5gt", { desc = "Tab 5" })
map("n", "<A-6>", "6gt", { desc = "Tab 6" })
map("n", "<A-7>", "7gt", { desc = "Tab 7" })
map("n", "<A-8>", "8gt", { desc = "Tab 8" })
map("n", "<A-9>", "9gt", { desc = "Tab 9" })

map("n", "<leader>mm", "<cmd>make<CR>", { desc = "Run make" })
map("n", "<leader>mo", "<cmd>copen<CR>", { desc = "Open quickfix" })
map("n", "<leader>mc", "<cmd>cclose<CR>", { desc = "Close quickfix" })
map("n", "<leader>mn", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
map("n", "<leader>mp", "<cmd>cprevious<CR>", { desc = "Previous quickfix item" })
