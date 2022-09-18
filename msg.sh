#!/bin/sh

	FMT_RED=$(printf '\033[31m')
	FMT_GREEN=$(printf '\033[32m')
	FMT_YELLOW=$(printf '\033[33m')
	FMT_BLUE=$(printf '\033[34m')
	FMT_BOLD=$(printf '\033[1m')
	FMT_RESET=$(printf '\033[0m')

test() {
printf "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓\n";
printf "┃ ╭━━━╮╱╱╱╱╱╭╮╭━━━╮╱╱╱╱╭╮      ┃\n";
printf "┃ ┃╭━╮┃╱╱╱╱╱┃┃┃╭━╮┃╱╱╱╭╯╰╮     ┃\n";
printf "┃ ┃╰━╯┣━━┳━━┫┃┃╰━╯┣━━┳┻╮╭╋╮╱╭╮ ┃\n";
printf "┃ ┃╭━━┫╭╮┃╭╮┃┃┃╭━━┫╭╮┃╭┫┃┃┃╱┃┃ ┃\n";
printf "┃ ┃┃╱╱┃╰╯┃╰╯┃╰┫┃╱╱┃╭╮┃┃┃╰┫╰━╯┃ ┃\n";
printf "┃ ╰╯╱╱╰━━┻━━┻━┻╯╱╱╰╯╰┻╯╰━┻━╮╭╯ ┃\n";
printf "┃ ╱╱╱╱╱╱╱╱╱╱╱╱𝔹𝕪 𝕥𝕙𝕫𝕖𝕣𝕚𝕓𝕚╭━╯┃  ┃\n";
printf "┃ ╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╰━━╯  ┃\n";
printf "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛\n"
echo "┃> Installation"
printf "┃${FMT_YELLOW}> Cloning PoolParty.${FMT_RESET}"
sleep 1
printf "\r\033[K┃${FMT_YELLOW}> Cloning PoolParty..${FMT_RESET}"
sleep 1
printf "\r\033[K┃${FMT_YELLOW}> Cloning PoolParty...${FMT_RESET}"
sleep 2
printf "\r\033[K┃${FMT_GREEN}> Install success !${FMT_RESET}\n"
}

test