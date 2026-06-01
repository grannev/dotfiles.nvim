local map = vim.keymap.set

map("n", "<leader>w", "<cmd>w<CR>")
map("n", "<leader>q", "<cmd>q<CR>")
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

map("n", "<leader>sv", "<cmd>vsplit<CR>")
map("n", "<leader>sh", "<cmd>split<CR>")

map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

map("n", "<leader>bn", "<cmd>bnext<CR>")
map("n", "<leader>bp", "<cmd>bprevious<CR>")
map("n", "<leader>bd", "<cmd>bdelete<CR>")
map("n", "<leader>bl", "<cmd>ls<CR>")

map("n", "<A-Left>", "<cmd>tabprevious<CR>")
map("n", "<A-Right>", "<cmd>tabnext<CR>")

map("n", "<leader>tt", "<cmd>tabnew<CR>")
map("n", "<leader>tc", "<cmd>tabclose<CR>")
map("n", "<leader>to", "<cmd>tabonly<CR>")

map("n", "<A-1>", "1gt")
map("n", "<A-2>", "2gt")
map("n", "<A-3>", "3gt")
map("n", "<A-4>", "4gt")
map("n", "<A-5>", "5gt")
map("n", "<A-6>", "6gt")
map("n", "<A-7>", "7gt")
map("n", "<A-8>", "8gt")
map("n", "<A-9>", "9gt")

map("n", "<A-S-Left>", "<cmd>tabmove -1<CR>")
map("n", "<A-S-Right>", "<cmd>tabmove +1<CR>")

map("n", "\27[1;4D", "<cmd>tabmove -1<CR>")
map("n", "\27[1;4C", "<cmd>tabmove +1<CR>")


map("n", "<leader>mm", "<cmd>make<CR>", { desc = "Run make" })
map("n", "<leader>mo", "<cmd>copen<CR>", { desc = "Open quickfix" })
map("n", "<leader>mc", "<cmd>cclose<CR>", { desc = "Close quickfix" })
map("n", "<leader>mn", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
map("n", "<leader>mp", "<cmd>cprevious<CR>", { desc = "Previous quickfix item" })
