-- 1. Definição da Paleta de Cores Extraída da Imagem
local c = {
	bg = "#15181a", -- bg = "#14141a", -- Fundo preto azulado
	fg = "#ffffff", -- Texto normal branco (como o texto selecionado)

	orange = "#e88333", --"#d75f00", -- Cor dos comandos como 'export', 'alias', 'shopt'
	st_orange = "#e04f2b",
	cyan = "#27e3e3", -- Cor das variáveis LESS_TERMCAP_*
	magenta = "#d700af", -- Símbolos, atribuições (=) e parênteses $()
	pink = "#ff5fdf", -- Conteúdo de comandos como 'tput'
	violet = "#8B86BB",
	sft_violet = "#a9a1e1",
	blue = "#005fff", -- Títulos comentados como '# Support colors in less'
	red = "#d70000", -- Avisos e saídas de erro em caminhos como '2>/dev/null'
	sft_red = "#ec5f67",
	yellow = "#d7af00", -- Valores numéricos de escape e strings secundárias
	green = "#98be65", -- Parâmetros de sucesso ou finalizações normais
}

-- 2. Mapeamento de Grupos de Sintaxe do Neovim
local highlights = {
	-- Estrutura Geral da Interface
	Normal = { fg = c.fg, bg = c.bg },
	Comment = { fg = c.violet, italic = true }, -- Comentários em Azul igual à imagem

	-- Elementos de Código Base
	Keyword = { fg = c.orange, bold = true }, -- 'export', 'alias' em Laranja
	Statement = { fg = c.orange }, -- Declarações estruturais
	Identifier = { fg = c.cyan }, -- Variáveis LESS_TERMCAP_* em Ciano

	-- Operadores e Strings
	Operator = { fg = c.sft_red }, -- Sinais de '=' e delimitadores em Magenta
	String = { fg = c.pink }, -- Conteúdo de strings internas em Rosa
	Special = { fg = c.yellow }, -- Códigos de cor numérica e escapes em Amarelo

	-- Erros e Condições de Saída
	Error = { fg = c.red, bold = true }, -- Fluxos de erro em Vermelho
	PreProc = { fg = c.green }, -- Diretivas e inclusões em Verde

	-- Elementos Visuais Especiais da Imagem
	Visual = { fg = c.bg, bg = c.fg }, -- Destaque invertido igual ao cursor em 'cdspell'
}

-- 3. Aplicação do Tema no Neovim
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end
vim.g.colors_name = "meutema_terminal"

for group, settings in pairs(highlights) do
	vim.api.nvim_set_hl(0, group, settings)
end
