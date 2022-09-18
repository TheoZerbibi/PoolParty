#!/bin/sh

set -e

USER=${USER:-$(id -u -n)}
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"

DIR="${DIR:-$HOME/.poolparty}"
REPO=${REPO:-TheoZerbibi/PoolParty}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-master}

if [ -t 1 ]; then
	is_subshell() {
		true
	}
else
	is_subshell() {
		false
	}
fi

header() {
	printf "┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓\n";
	printf "┃ ╭━━━╮╱╱╱╱╱╭╮╭━━━╮╱╱╱╱╭╮      ┃\n";
	printf "┃ ┃╭━╮┃╱╱╱╱╱┃┃┃╭━╮┃╱╱╱╭╯╰╮     ┃\n";
	printf "┃ ┃╰━╯┣━━┳━━┫┃┃╰━╯┣━━┳┻╮╭╋╮╱╭╮ ┃\n";
	printf "┃ ┃╭━━┫╭╮┃╭╮┃┃┃╭━━┫╭╮┃╭┫┃┃┃╱┃┃ ┃\n";
	printf "┃ ┃┃╱╱┃╰╯┃╰╯┃╰┫┃╱╱┃╭╮┃┃┃╰┫╰━╯┃ ┃\n";
	printf "┃ ╰╯╱╱╰━━┻━━┻━┻╯╱╱╰╯╰┻╯╰━┻━╮╭╯ ┃\n";
	printf "┃ ╱╱╱╱╱╱╱╱╱╱╱╱𝔹𝕪 𝕥𝕙𝕫𝕖𝕣𝕚𝕓𝕚╭━╯┃  ┃\n";
	printf "┃ ╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╰━━╯V4┃\n";
	printf "┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛\n"
}

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

fmt_underline() {
	is_subshell && printf '\033[4m%s\033[24m\n' "$*" || printf '%s\n' "$*"
}

# shellcheck disable=SC2016 # backtick in single-quote
fmt_code() {
  is_subshell && printf '`\033[2m%s\033[22m`\n' "$*" || printf '`%s`\n' "$*"
}

fmt_error() {
  printf '\r\033[K┃%s>Error: %s%s\n' "${FMT_BOLD}${FMT_RED}" "$*" "$FMT_RESET" >&2
}

setup_color() {
	if ! is_subshell; then
		FMT_RAINBOW=""
		FMT_RED=""
		FMT_GREEN=""
		FMT_YELLOW=""
		FMT_BLUE=""
		FMT_BOLD=""
		FMT_RESET=""
		return
	fi

	FMT_RAINBOW="
		$(printf '\033[38;5;196m')
		$(printf '\033[38;5;202m')
		$(printf '\033[38;5;226m')
		$(printf '\033[38;5;082m')
		$(printf '\033[38;5;021m')
		$(printf '\033[38;5;093m')
		$(printf '\033[38;5;163m')
	"

	FMT_RED=$(printf '\033[31m')
	FMT_GREEN=$(printf '\033[32m')
	FMT_YELLOW=$(printf '\033[33m')
	FMT_BLUE=$(printf '\033[34m')
	FMT_BOLD=$(printf '\033[1m')
	FMT_RESET=$(printf '\033[0m')
}

setup_poolparty() {
	echo "┃> Installation"
	printf "┃> Cloning PoolParty."

	git clone --quiet ${REMOTE} ${DIR} || {
		[ ! -d "$DIR" ] || {
			rm -rf "$DIR" 2>/dev/null
		}
		fmt_error "Failed to clone PoolParty"
		exit 1
	}
	
	chmod +x ${DIR}/*.sh
	printf "\r\033[K┃${FMT_GREEN}> Successfully cloned Poolparty.${FMT_RESET}\n"
}

setup_alias() {
	printf "┃> Creating alias."
	if ! command_exists pp; then
		echo "alias pp=$DIR/poolparty.sh" >> $HOME/.zshrc;
	fi
	printf "\r\033[K┃${FMT_GREEN}> Successfully create alias.${FMT_RESET}\n"
}

print_success() {
	clear
	header
	cat << EOF
┃$FMT_GREEN> PoolParty a bien été installé !$FMT_RESET
┃
┃> Pour l'utiliser tu dois te placer dans
┃$FMT_BOLD  le fichier racine de ton module.$FMT_RESET
┃  Il suffit ensuite de faire$FMT_RESET$FMT_BOLD pp$FMT_RESET.
┃
┃> PS :Si l'alias \`${FMT_BOLD}pp${FMT_RESET}\` ne fonctionne pas,
┃  faite la commande : \`${FMT_BOLD}source ~/.zshrc${FMT_RESET}\`
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}

main() {
	
	header
	setup_color
	
	if ! command_exists zsh; then
		printf "┃${FMT_RED}> %s\n%s%s\n" "${FMT_BOLD}Zsh is not installed.${FMT_RESET}" "┃${FMT_RED}> Please install zsh first." "$FMT_RESET" >&2
		exit 1
	fi

	command_exists git || {
		fmt_error "Git it is not installed"
		exit 1
	}

	if [ -d "$DIR" ];then
		cat << EOF
┃> PoolParty is already install !
┃  The script doesn't work ? Try \`source ~/.zshrc\`.
┃  If you want remove or reinstall the script, just delete the PoolParty folder ($DIR).
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
		exit 1
	fi

	setup_poolparty
	setup_alias

	sleep 1

	print_success
	exec zsh -l
}

main "$@"