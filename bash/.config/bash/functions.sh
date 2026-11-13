# ~/.config/bash/functions.sh

# variaveis
# array dos hostnames 
HARDWARES=("cortana" "rodney" "endurance")

#vms, SSH's and LIS
vm() { 
  if [[ $1 == 'debian' ]]; then
    echo "Iniciando debian" 
    "$HOME/vms/debian-cli/run.sh" "${@:2}"
    local rc=$?
    return $rc
  else echo "Não existe nenhuma vm chamada '$1'"
  fi
}

lis() {
  # How it works: lis [ARG $1 = FILE or DIR to send] [ARG $2 = destiny (HARDWARE)]
  local ARGUMENT_TYPE=""
  local DESTINY="$2"
  local INPUT=""

  # verifica se foi passado algum argumento
  if [[ -z "$1" ]]; then
    echo -e "${RED}Erro:${NC} Nenhum argumento fornecido."
    return 1
  fi

  # verifica se o argumento 2, o destino, foi enviado.
  # se não houver destino, verifica em qual maquina 
  # está a rodar e envia para uma maquina por padrão.
  # endurance ou qualquer outro: enviar para rodney em ~/ALIS
  # cortana ou rodney: envia para endurance em ~/ALIS 
  if [[ -z "$DESTINY" ]]; then
    if [[ $HOSTNAME == "cortana" || $HOSTNAME == "rodney" ]]; then 
      DESTINY="endurance"
      echo -e "Enviando para ${BLUE}Endurance${NC}..."
    else
      DESTINY="rodney"
      echo -e "Enviando para ${BLUE}Rodney${NC}..."
    fi
  fi

  if [[ ! " ${HARDWARES[*]} " =~ " $DESTINY " && -n "$DESTINY" ]]; then
    echo -e "Opção inválida\nDestino '$2' não reconhecido."
    return 1
  fi

  # filtragem pelo tipo do argumento: Arquivo ou diretório válido -> passa, do contrário Erro.
  if [[ -f "$1" ]]; then
    ARGUMENT_TYPE="FILE"
    SIZE_BYTES=$(stat -c %s "$1")
  elif [[ -d "$1" ]]; then
    ARGUMENT_TYPE="DIR"
    SIZE_BYTES=$(du -sb "$1" | cut -f1)
  else  
    echo -e "${RED}Erro:${NC} Argumento inválido. Não é um diretório nem arquivo."
    return 1
  fi

  # se arquivo ou diretório tiver mais que 1gb, perguntar se realmente quer enviar o arquivo.
  if (( SIZE_BYTES > 1073741824 )); then
    SIZE_GB=$(awk "BEGIN {printf \"%.2f\", $SIZE_BYTES / 1073741824}")
    if [[ $ARGUMENT_TYPE == "DIR" ]]; then
      echo -e "Diretório ${BLUE}'$1'${NC} tem ${RED}${SIZE_GB}GB${NC}."
      echo -e "Tem certeza que quer enviar para o ${BLUE}Rodney${NC}?"
    elif [[ $ARGUMENT_TYPE == "FILE" ]]; then
      echo -e "Arquivo  ${BLUE}'$1'${NC} tem ${RED}${SIZE_GB}GB${NC}."
      echo -e "Tem certeza que quer enviar para o ${BLUE}${DESTINY}${NC}?"
    fi

    # loop para guardar INPUT 
    while true; do
      read -r -p "${GREY}(y/n)${NC}: " INPUT
      case $INPUT in
        Y|y|Yes|yes|S|s|Sim|sim)
          break
          ;;
        N|n|No|no|Nao|nao)
          echo -e "${BLUE}'$1'${NC} não será enviado."
          return 0 
          ;;
        *)
          echo -e "${RED}Resposta inválida.${NC}"
          ;;
      esac
    done
  fi

  # continua aqui a lógica de enviar para o servidor. (usando o rsync por favor, Thiago)
  if rsync -avz --info=progress2 "$1" "$DESTINY:/home/thiago/ALIS/"; then
    echo -e "\n"
    echo -e "Transferência concluída!\n${BLUE}$1${NC} --> ${BLUE}$DESTINY${NC}:~/ALIS"
  else
    echo -e "Erro durante a transferência.\nTem certeza que tem os hosts no ${BLUE}~/.ssh/config${NC}?"
    return 1
  fi
}

# script de instalacao de pacotes com pacman -S
# A ideia é mostrar todas as opções de downloads
# relacionado ao argumento $1.
# ao selecionar o pacote, mostra detalhes importantes
# usando o pacman -Si, seguido pelo pacman -S para
# efetivamente instalar o pacote. 
# É um aglomerado de comandos pacman.
pacs() {
  # guarda o argumeto $1 como pacote a ser instalado
  local PACKAGE="$1"
  local INPUT=""

  # filtro argumento $1 vazio
  if [[ -z "$PACKAGE" ]]; then
    echo -e "Por favor, escreva o nome do pacote que você quer instalar."
    return 1
  fi 

  # verifica e imprime detalhes do pacote antes de instalar. 
  sudo pacman -Ss "$PACKAGE"

  echo -e "\nQual pacote deseja instalar?"
  read -r -p "${GREY}(Vazio = ${PACKAGE})${NC}: " INPUT

  # declara que input = ao argumento $1 inicial se for vazio.
  if [[ -z "$INPUT" ]]; then
    INPUT="$PACKAGE"
  fi

  # imprime as informações detalhadas do pacote antes da instalação.
  echo -e "\nInformações do pacote ${BLUE}$INPUT${NC}."
  if sudo pacman -Si "$INPUT" ; then
   sudo pacman -S "$INPUT" 
  else
    echo -e "${RED}Pacote não encontrado ou não pôde ser instalado.${NC}" 
    return 1
  fi  
}

