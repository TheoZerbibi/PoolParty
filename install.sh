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
	printf "┃ ╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╰━━╯  ┃\n";
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
	header
	echo "┃> Installation"
	printf "┃> Cloning PoolParty."

	git init --quiet "$DIR" && cd "$DIR" \
  && git config core.eol lf \
  && git config core.autocrlf false \
  && git config fsck.zeroPaddedFilemode ignore \
  && git config fetch.fsck.zeroPaddedFilemode ignore \
  && git config receive.fsck.zeroPaddedFilemode ignore \
  && git config oh-my-zsh.remote origin \
  && git config oh-my-zsh.branch "$BRANCH" \
  && git remote add origin "$REMOTE" \
  && git fetch --depth=1 origin \
  && git checkout -b "$BRANCH" "origin/$BRANCH" || {
	[ ! -d "$ZSH" ] || {
	  cd -
	  rm -rf "$ZSH" 2>/dev/null
	}
	fmt_error "git clone of oh-my-zsh repo failed"
	exit 1
  }
  # Exit installation directory
  cd -

  echo
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
}

main "$@"