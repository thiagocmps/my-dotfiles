## my-dotfiles

Criado para separar as configurações de alguns programas gerais do meu repositório _aperture-interfaces-dotfiles_, que tem um foco muito maior em tematizar uma sessão _hyprland_ do que uma _'toolbox'_.

## Programas/pacotes que utilizo

1. **Neovim** - IDE/Editor de texto padrão
2. **bash** - Minhas configurações bash favoritas estão aqui (aliases, variáveis de ambiente, etc)
3. **Ranger** - Gerenciador de arquivos que utilizo junto do Neovim _deprecated_

### Neovim

Algumas informações úteis da minha configuração:

> [Estrutura de pastas](#estrutura-de-pastas) \
> [Plugins Neovim](#plugins-neovim)

#### Estrutura de pastas

Ela segue o modelo padrão de leitura de plugins em `.lua` com mais algumas mudanças para facilitar a leitura e edição. Segue o `tree -a` com coreszinhas pra facilitar:

- <span style="color: #EC5858;"> vermelho </span>: Vai sair do repositório em breve.
- <span style="color: #B1C5E3;">Azul acinzentado</span>: Sem modificação.

<pre>
<span style="color: #B1C5E3;"><b>
<span style="font-size: 18px">nvim</span> 
├<span style="color: #EC5858;">── assets</span> 
│   <span style="color: #EC5858;">└── alpha_header.txt</span> 
├── colors  
│   └── flux.lua
├── init.lua
├── lazy-lock.json
├── lsp
│   ├── bashls.lua
│   ├── lua_ls.lua
│   ├── rust_analyzer.lua
│   └── ts_ls.lua
├── lua
│   ├── config
│   │   ├── keymaps.lua
│   │   ├<span style="color: #EC5858;">── lualine.lua.old </span>
│   │   ├── sessions.lua
│   │   ├── statusline.lua
│   │   └── templates.lua
│   ├── plugins
│   │   ├<span style="color: #EC5858;">── alpha.lua </span>
│   │   ├── comment.lua
│   │   ├── conform.lua
│   │   ├── glow.lua
│   │   ├── live-server.lua
│   │   ├── lsp-config.lua
│   │   ├<span style="color: #EC5858;">── lualine.lua.old </span>
│   │   ├── neotree.lua
│   │   ├<span style="color: #EC5858;">── stoics-theme.lua.old </span>
│   │   ├── telescope.lua
│   │   ├── treesitter.lua
│   │   └── which-key.lua
│   └── vim-options.lua
└── templates 
    ├── skeleton.css
    ├── skeleton.html
    ├── skeleton.js
    └── skeleton.vue

<u>8 directories, 30 files</u>
</span>
</pre>

#### Plugins Neovim

<span style="color: #EC5858;">**`alpha.lua`**</span>: Cria uma tela inicial personalizada (dashboard) ao abrir o Neovim.

**`comment.lua`**: Facilita comentar e descomentar linhas ou blocos de código.

**`conform.lua`**: Configura a formatação automática de código através de formatadores externos.

**`glow.lua`**: Permite visualizar ficheiros Markdown formatados diretamente no terminal.

**`live-server.lua`**: Configura um servidor local para visualizar páginas web e acompanhar alterações em tempo real.

**`lsp-config.lua`**: Configura os Language Servers (LSP), oferecendo autocomplete, diagnóstico e navegação no código.

<span style="color: #EC5858;">**`lualine.lua.old`**</span>: Configuração antiga da barra de estado, que apresenta informações como ficheiro, modo e estado do Git.

**`neotree.lua`**: Adiciona um explorador de ficheiros e diretórios dentro do Neovim.

<span style="color: #EC5858;">**`stoics-theme.lua.old`**</span>: Configuração antiga do tema visual (cores) do Neovim.

**`telescope.lua`**: Permite pesquisar ficheiros, textos, buffers e outros elementos através de uma interface interativa.

**`treesitter.lua`**: Melhora o reconhecimento da sintaxe do código, oferecendo realce de cores e análise estrutural.

**`which-key.lua`**: Mostra os atalhos de teclado disponíveis quando pressionas uma tecla de atalho ou combinação incompleta.

## Scripts/plugins que utilizo

1. **ble.sh** - Autocomplete e gerenciador de cores para bash, honestamente uso só pra colorir meu terminal, tenho um apego ao bash e nãopretendo mudar para Zsh.

## Problemas encontrados

O `install.sh` tá <span style="color: #EC5858;">**quebrado**</span>. Ao rodar o script, ele quebra logo após o download das dependências.

## Melhorias pretendidas

A liberdade de poder instalar diversos plugins com funcionalidades diferentes é muito interessante e é um dos diferenciais de se usar `neovim` ao invés do clássico `vim` (ou `vi`), mas é algo que pretendo diminuir gradualmente por questões de dependência e complexidade. Ainda vai ter plugins que facilitam muito a vida, como o _Mason_ e o _LiveServer_, mas outros que podem ser facilmente substituidos por comandos simples em bash ou questões meramente estéticas vão desaparecer.
