vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 12

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Adiciona pulos maiores que 5 linhas ao histórico (jumplist)
vim.keymap.set("n", "k", [[v:count > 5 ? "m'" . v:count . "k" : "k"]], { expr = true, silent = true })
vim.keymap.set("n", "j", [[v:count > 5 ? "m'" . v:count . "j" : "j"]], { expr = true, silent = true })

-- Atalho: Leader + i indenta o arquivo inteiro e volta para onde você estava
vim.keymap.set("n", "<Leader>i", "gg=G<C-o>", { desc = "Indentar código inteiro" })
