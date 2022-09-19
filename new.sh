#!/bin/sh
# STILL WORKING-ON

set -e

AUTHOR="Theo ZERIBI - thzeribi";
VERSION="4.0.0";

REPO=${REPO:-TheoZerbibi/PoolParty}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
REMOTE_V="${REMOTE_V:-$(curl -s "https://raw.githubusercontent.com/${REPO}/master/.version")}"


PPDIR="${DIR:-$HOME/.poolparty}"

USER=${USER:-$(id -u -n)}
BASEDIR="${BASEDIR:-$(dirname "$0")}";
DIR="${DIR:-$(pwd)}";
DIRNAME="${DIRNAME:-$(basename "$PWD")}";

NORM=${NORM:-yes}
STATUS=${NORM:-yes}
COMP=${NORM:-yes}
HARD=${HARD:-no}

if [ -t 1 ]; then
	is_subshell() {
		true
	}
else
	is_subshell() {
		false
	}
fi

command_exists() {
	command -v "$@" >/dev/null 2>&1
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

fmt_underline() {
	is_subshell && printf '\033[4m%s\033[24m\n' "$*" || printf '%s\n' "$*"
}

fmt_code() {
	is_subshell && printf '`\033[2m%s\033[22m`\n' "$*" || printf '`%s`\n' "$*"
}

fmt_error() {
	printf '\r\033[K┃%s>Error: %s%s\n' "${FMT_BOLD}${FMT_RED}" "$*" "$FMT_RESET" >&2
}



diff_version() {
	if [ $VERSION != $REMOTE_V ]; then
		header
		cat << EOF
┃$FMT_BOLD> Une nouvelle version de PoolParty est disponible !$FMT_RESET
┃
┃> Pour l'installer, merci de faire la commande $(fmt_code "pp -u")
┃  ou $(fmt_code "pp --update")
┗━━━━━━━━━━━━━━━━━━┛
EOF
	fi
}

header() {
	cat << EOF
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ ╭━━━╮╱╱╱╱╱╭╮╭━━━╮╱╱╱╱╭╮      ┃
┃ ┃╭━╮┃╱╱╱╱╱┃┃┃╭━╮┃╱╱╱╭╯╰╮     ┃
┃ ┃╰━╯┣━━┳━━┫┃┃╰━╯┣━━┳┻╮╭╋╮╱╭╮ ┃
┃ ┃╭━━┫╭╮┃╭╮┃┃┃╭━━┫╭╮┃╭┫┃┃┃╱┃┃ ┃
┃ ┃┃╱╱┃╰╯┃╰╯┃╰┫┃╱╱┃╭╮┃┃┃╰┫╰━╯┃ ┃
┃ ╰╯╱╱╰━━┻━━┻━┻╯╱╱╰╯╰┻╯╰━┻━╮╭╯ ┃
┃ ╱╱╱╱╱╱╱╱╱╱╱╱𝔹𝕪 𝕥𝕙𝕫𝕖𝕣𝕚𝕓𝕚╭━╯┃  ┃
┃ ╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╰━━╯V4┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
EOF
}

header_close() {
	cat << EOF
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ ╭━━━╮╱╱╱╱╱╭╮╭━━━╮╱╱╱╱╭╮      ┃
┃ ┃╭━╮┃╱╱╱╱╱┃┃┃╭━╮┃╱╱╱╭╯╰╮     ┃
┃ ┃╰━╯┣━━┳━━┫┃┃╰━╯┣━━┳┻╮╭╋╮╱╭╮ ┃
┃ ┃╭━━┫╭╮┃╭╮┃┃┃╭━━┫╭╮┃╭┫┃┃┃╱┃┃ ┃
┃ ┃┃╱╱┃╰╯┃╰╯┃╰┫┃╱╱┃╭╮┃┃┃╰┫╰━╯┃ ┃
┃ ╰╯╱╱╰━━┻━━┻━┻╯╱╱╰╯╰┻╯╰━┻━╮╭╯ ┃
┃ ╱╱╱╱╱╱╱╱╱╱╱╱𝔹𝕪 𝕥𝕙𝕫𝕖𝕣𝕚𝕓𝕚╭━╯┃  ┃
┃ ╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╰━━╯V4┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
EOF
}

update_pp() {
	rm -rf $PPDIR
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/TheoZerbibi/PoolParty/master/install.sh)"
}

print_help() {
	header
	cat << EOF
┃> --help, -h    : Affiche l'aide.
┃> --version, -v : Affiche la version.
┃> --update, -p  : Update PoolParty.
┃
┃> --skip-norm, -n   : Ne vérifie pas la norme.
┃> --skip-status, -g : Ne vérifie pas le status git.
┃> --skip-comp, -c   : Ne vérifie pas la compilation.
┃
┃> --hard-check, -hard : Compile avec scan-build-12.
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
EOF
}

print_version() {
	header_close
	printf "┃$FMT_BOLD> Version : $VERSION $FMT_RESET\t       ┃\n"
	printf "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛\n"
}

parse_arg() {
		while [ $# -gt 0 ]; do
		case $1 in
			--version|-v) print_version; exit 1 ;;
			--update|-u) update_pp; exit 1 ;;
			--help|-h) print_help; exit 1 ;;
			--skip-norm|-n) NORM=no ;;
			--skip-status|-g) STATUS=no ;;
			--skip-comp|-c) COMP=no ;;
			--hard-check|-hard) HARD=yes ;;
		esac
		shift
	done
}

main()
{

	setup_color

	parse_arg "$@"
	diff_version

	if [ "$NORM" = yes ]; then
		echo "norm"
	fi
	if [ "$STATUS" = yes ]; then
		echo "status"
	fi
	if [ "$COMP" = yes ]; then
		echo "comp"
	fi
}

main "$@"
