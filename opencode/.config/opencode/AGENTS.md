# Instruções globais

## Idioma
- Responda em português do Brasil. Código, identificadores e comentários em inglês.

## Estilo
- Seja direto: sem introdução, sem repetir o pedido, sem resumo redundante.
- Diga o que mudou, onde (arquivo:linha) e o que não foi verificado.

## Escopo
- Faça a menor mudança que resolve. Siga os padrões e camadas que o projeto já usa.
- Nada de refatoração, abstração, opção ou configuração que não foi pedida.
- Não crie README, documentação ou comentários extras. Não adicione dependência sem pedir.

## Verificação
- Depois de mudar código, rode os testes/lint/typecheck que o projeto tiver.
- Se não houver, ou se algo não puder rodar, diga explicitamente.

## Git
- Não faça commit, push, rebase ou force sem pedido explícito.
- Nunca reescreva histórico. Commits no formato Conventional Commits, em inglês.
- Investigue arquivos desconhecidos antes de apagar ou sobrescrever; não toque no que não é da tarefa.

## Segurança e ambiente
- Não leia nem imprima `.env`, tokens ou credenciais. Nunca hardcode segredo.
- Avise antes de alterar configuração global, Docker, systemd ou qualquer coisa fora do projeto.
