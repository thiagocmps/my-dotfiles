# ~/.config/bash/07_code_templates.sh

KNOWN_LANGUAGES=( "express" "golang" )
TEMPLATE_PATH="$HOME/.config/code-templates"

# templates de projetos backend
# api [$1 = linguagem] [$2 = nome-projeto] [$3 = caminho]
# se $3 não for preenchido, assume diretorio padrão.
createapi() {
  local LANGUAGE="$1"
  local PROJECT_NAME="$2"
  local PROJECT_PATH="$3"
  local DEFAULT_PROJECT_PATH="$HOME/local-projects"
  # ideia em potencial: criar uma especie de logger, ao inves de simplesmente
  # fazer return 1 quando algo estiver errado, guardar o estado em uma 
  # variavel e criar um verificador que printaria todos os erros diretamente.
  # O que isso corrige: atualmente, se eu por uma linguagem inválida, 
  # o codigo para antes de ver se há um erro em outras partes

  # Verifica se existe a linguagem no array KNOWN_LANGUAGES 
  if [[ -z "$LANGUAGE" || ! " ${KNOWN_LANGUAGES[*]} " =~ " $LANGUAGE " && -n "$LANGUAGE" ]]; then
    echo -e "Linguagem/Framework não suportada: ${RED}'$LANGUAGE'${NC}"  
    return 1
  fi

  # filra nome do projeto evitando / e diretórios existentes. 
  # queria obrigar o utilizador a passar o nome entre aspas, mas aparentemente
  # o bash ignora as aspas passadas nos argumentos.
  # Boa prática: sempre escrever nome do projeto entre aspas.
  if [[ -d "$PROJECT_NAME" || "$PROJECT_NAME" == *"/"* ]]; then
    echo -e "Nome do projeto ${BOLD}inválido${NORMAL}:\n${RED}'${PROJECT_NAME}'${NC} potencialmente criaria subpastas."
    return 1
  else
    if [[ -z "$PROJECT_NAME" ]]; then
      echo -e "Nome do projeto ${BOLD}inválido${NORMAL}: ${RED}Nome vazio${NC}."  
      return 1
    fi
  fi

  # se caminho vier vazio, determina um caminho padrão
  if [[ -z "$PROJECT_PATH" ]]; then
    if [[ -d "$DEFAULT_PROJECT_PATH" ]]; then
      PROJECT_PATH="$DEFAULT_PROJECT_PATH"
    else
      echo -e "Caminho não mencionado.\nCaminho padrão ${BLUE}'${DEFAULT_PROJECT_PATH}'${NC} não existe."
      return 1   
    fi
    # verificar se existe esse caminho, bloqueia se não existir
  elif [[ ! -d "$PROJECT_PATH" ]]; then
    echo -e "Caminho ${BOLD}não existe${NORMAL}.\nRode o comando novamente com um caminho real."  
    return 1
  fi

  # verifica se já existe projeto/diretorio com o nome do projeto
  if [[ -d "$PROJECT_PATH/$PROJECT_NAME" ]]; then
    echo -e "Projeto já existe nesse caminho:\n"
    echo -e "${RED}'$PROJECT_PATH/$PROJECT_NAME'${NC}"
    return 1
  fi

  echo -e "Veriicação antes de criar '${PROJECT_NAME}':"
  printf "\n"
  echo -e "Linguagem/Framework do projeto: ${BLUE}'${LANGUAGE}'${NC}"
  echo -e "Nome do projeto: ${BLUE}'${PROJECT_NAME}'${NC}"
  echo -e "Caminho do projeto: ${BLUE}'${PROJECT_PATH}'${NC}"
  printf "\n"
  echo -e "Prosseguir com a criação do projeto?"
  read -r -p "${GREY}(y/n)${NC}: " INPUT

  case $INPUT in
    s|S|sim|Sim|y|Y|yes|Yes)
      echo -e "\nCriando projeto..." 
      "create_${LANGUAGE}" "${PROJECT_NAME}" "${PROJECT_PATH}"
      return 0
      ;;
    n|N|nao|não|Nao|Não|no|No)
      echo -e "Abortando..."
      return 0
      ;;
    *)
      echo "Opção ${RED}inválida${NC}.";
      return 1
      ;;
  esac
}

create_express() {
  local PROJECT_NAME="$1"
  local PROJECT_PATH="$2"
  echo -e "API em ${RED}Express${NC}\n${BLUE}'$PROJECT_NAME'${NC} criado em ${BLUE}'$PROJECT_PATH'${NC}."

  # primeiro, cria a pasta do projeto
  mkdir "${PROJECT_PATH}/${PROJECT_NAME}" && \
    echo -e "${BLUE}${PROJECT_PATH}/${PROJECT_NAME}${NC} criado."

    # muda para o diretório do projeto
    cd "${PROJECT_PATH}/${PROJECT_NAME}" ||  {
      echo "Erro ao aceder a pasta do projeto"
          return 1
    }  

    # nome do pacote do node nao varia nos principais distros que uso, então mantenho assim
    # para o fedora, nodejs já é o suficiente,ele puxa o pacote nodejs-npm direto.
    if ! command -v node &>/dev/null; then
      $PKG_MANAGER nodejs
    fi

    # instalar npm nas outras distros
    if ! command -v npm &>/dev/null && [[ ! $THIS_OS_TYPE =~ ^fedora ]]; then
      $PKG_MANAGER npm 
    fi

    # Inicia repositório git
    git init || {
      echo -e "Falha ao iniciar repositório git."
    }

    # copia dos templates para o diretório do projeto
    rsync -a "$TEMPLATE_PATH/express/" "${PROJECT_PATH}/${PROJECT_NAME}/" && \
      echo -e "Projeto criado com sucesso!"

      # muda o nome do projeto
      npm pkg set name="$PROJECT_NAME" 

      # instala as dependências
      npm install && echo -e "Dependências instaladas com sucesso."

      git add . && \
        git commit -m "feat: Base structure." \

}

create_golang() {
  local PROJECT_NAME="$1"
  local PROJECT_PATH="$2"
  local PACKAGE_NAME="go"

  # primeiro, cria a pasta do projeto
  mkdir "${PROJECT_PATH}/${PROJECT_NAME}" && \
    echo -e "${BLUE}${PROJECT_PATH}/${PROJECT_NAME}${NC} criado."

    # muda para o diretório do projeto
    cd "${PROJECT_PATH}/${PROJECT_NAME}" ||  {
      echo "Erro ao aceder a pasta do projeto"
          return 1
    } 

    # verfica se existe go e instala caso nao tenha
    if ! command -v go &>/dev/null; then
      if [[ "$THIS_OS_TYPE" =~ ^fedora ]]; then
        PACKAGE_NAME="golang"
      elif [[ "$THIS_OS_TYPE" =~ ^debian ]]; then
        PACKAGE_NAME="golang-go"
      fi
      $PACKAGE_MANAGER $PACKAGE_NAME || {
        echo -e "Erro ao instalar pacote "$PACKAGE_NAME""
              return 1
      }
    fi

    # Inicia repositório git
    git init || {
      echo -e "Falha ao iniciar repositório git."
    }

    # inicia projeto go
    # arquivo main.go e go.mod criados aqui
    go mod init "github.com/thiagocmps/$PROJECT_NAME" 

    rsync -a "$TEMPLATE_PATH/golang/" "${PROJECT_PATH}/${PROJECT_NAME}/" && \
      echo -e "Projeto criado com sucesso!"
    
    git add . && \
      git commit -m "feat: Base structure."
}
