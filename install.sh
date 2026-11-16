#!/usr/bin/env bash
BOLD="\e[1m"
NORMAL="\e[0m"

cd "$(dirname "$0")"

printf "Bem vindo a instalação ${BOLD}dotfiles${NORMAL} do Thiago!\n"
printf "Escolha: "
printf "\n"
printf "0 - dotfiles\n"
printf "1 - packages\n"
printf "2 - Syncthing\n"
printf "3 - Ambos\n"
printf "\n"

while true; do
  read -r -p ">: " INPUT || exit 1
  case "$INPUT" in
    0)
      echo "Chamando instalador..."
      bash scripts/dotfiles-install.sh || exit 1
      break
      ;;
    1)
      echo "Chamando instalador..."
      bash scripts/packages-install.sh || exit 1
      break
      ;;
    3)
      echo "Chamando instaladores..."
      bash scripts/syncthing-install.sh || exit 1
      break
      ;;
    4)
      echo "Chamando instaladores..."
      bash scripts/dotfiles-install.sh && bash scripts/syncthing-install.sh || exit 1
      break
      ;;
    *)
      echo "Input inválido"
      ;;
  esac

done
