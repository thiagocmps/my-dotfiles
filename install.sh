#!/usr/bin/env bash
RED='\033[0;31m'
GREY='\033[90m'
GREEN='\e[32m'
BLUE='\e[34m'
NC='\033[0m' #sem cor, finaliza as cores
BOLD="\e[1m"
NORMAL="\e[0m"

cd "$(dirname "$0")"

printf "Bem vindo a instalação ${BOLD}dotfiles${NORMAL} do Thiago!\n"
printf "Escolha: "
printf "\n"
printf "0 - dotfiles\n"
printf "1 - Syncthing\n"
printf "2 - Ambos\n"
printf "\n"

while true; do
  read -r -p ">: " INPUT || exit 1

  case "$INPUT" in
    0)
      echo "Chamando instalador..."
      bash scripts/dotfiles-stow.sh || exit 1
      break
      ;;
    1)
      echo "Chamando instalador..."
      bash scripts/syncthing.sh || exit 1
      break
      ;;
    2)
      echo "Chamando instaladores..."
      bash scripts/dotfiles-stow.sh && bash scripts/syncthing.sh || exit 1
      break
      ;;
    *)
      echo "Input inválido"
      ;;
  esac

done
