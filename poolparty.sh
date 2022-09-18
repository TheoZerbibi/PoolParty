#!/bin/bash
# thzerib

# -- IDEA -- #
#
#	- Add git status check / : √;
#	- Add regex for include and function/ : X;
#	- Add Check file (ft_*)/ : X;
#	- Add Author check file/ : X;
#
#  -- /|\ -- #


# -- FIX BUG -- #
#
#	- Forbidden function return Ok but is KO/ : √;
#	- Folder is empty, add check in exo file, not just in C Mod file/ : X;
#
# -- /|\ -- #


VERSION=0.0.3;
AUTHOR="Theo ZERIBI - thzeribi";

#COLOR
RED="\033[38;5;1m";
GREEN="\033[38;5;40m";
YELLOW="\033[38;5;226m";
GREENBACK="\033[1;4;42m";
ORANGEBACK="\033[1;4;48;5;208m";
WHITE="\033[1;15m";

#TEXT
UNDERLINE="\033[4m";
INVERTED="\033[7m";
DIM="\033[2m";
STOP="\033[0m";

#FILE
BASEDIR=$(dirname "$0");
DIR=${PWD};
LASTDIR=${PWD##*/};

#PARAM
NORM=0;
COMP=0;
GIT=0;
MOD=0;
NBR=0;

while getopts "vhncg" flag
do
	case $flag in

		v)
			clear
			sh $BASEDIR/msg.sh
			printf "[=============================================================================================================]\n"
			printf "\n\t${WHITE}Version : ${VERSION} \n\tAuthor : ${AUTHOR}\n${STOP}"
			printf "\n[=============================================================================================================]\n"
			printf "%-50s ${GREEN} [--- FINISH ---]\n"

			exit
			;;
		n)
			NORM=1
			;;
		c)
			COMP=1;
			;;
		m)
			MOD=1;
			;;
		g)
			GIT=1;
			;;
		h)
			sh $BASEDIR/msg.sh
			printf "[=============================================================================================================]\n"
			printf "\n\t${WHITE}--- Help page ---\n\n"
			printf "\t\t-h : Open help page.\n"
			printf "\t\-m : Don't chmod +x files.\n"
			printf "\t\t-v : Print current version.\n"
			printf "\t\t-n : Don't check the 42Norm.\n"
			printf "\t\t-g : Check git status.\n"
			printf "\t\t-c : Don't check the compilation.\n\n${STOP}"
			printf "[=============================================================================================================]\n"
			printf "%-50s ${GREEN} [--- FINISH ---]\n"
			exit
			;;
	esac
done

function git_status {
	printf "[=============================================================================================================]\n"
	printf "\n\t${WHITE}${UNDERLINE}--- GIT STATUS ---${STOP}\n\n"

	if ! git ls-files >& /dev/null; then
  		printf "\n\t\t\t\t\t\t${WHITE}No Respository here${STOP}\n\n"
		printf "[=============================================================================================================]\n"
		printf "\t\t\t\t\t\t${GREEN} [--- FINISH ---]\n"
		exit 0
	else
		if git diff-index --name-status --exit-code HEAD;
		then
  			printf "\n\t\t${WHITE}Repository is update${STOP}";
			printf "\n\n${GREEN}\t\t\t\t\t\t\t\t\t\t\t\t- OK √${STOP}\n"
		else
  			printf "\n\t\t${WHITE}Repository is not update${STOP}";
			printf "\n\n${RED}\t\t\t\t\t\t\t\t\t\t\t\t- KO X${STOP}\n"
		fi
	fi
	printf "\=============================================================================================================]\n"
}

function comp {
	printf "[=============================================================================================================]\n"
	printf "\n\t${WHITE}${UNDERLINE}--- COMPILATION ---${STOP}\n\n"

	if gcc -c ./*/ft*.c $BASEDIR/ft_main.c -Wall -Wextra -Werror
	then
		printf "\t\t${WHITE}All files check.${STOP}"
		printf "\n\n${GREEN}\t\t\t\t\t\t\t\t\t\t\t\t- OK √${STOP}\n"
		printf "[=============================================================================================================]\n"
	else
		printf "\n\n${RED}\t\t\t\t\t\t\t\t\t\t\t\t- KO X${STOP}\n"
		printf "[=============================================================================================================]\n"
	fi
	rm *.o
}

function forbidden {
	printf "[=============================================================================================================]\n"
	printf "\n\t${WHITE}${UNDERLINE}--- FORBIDDEN FUNCTION ---${STOP}\n\n"

	cat */* | grep --color -rsl 'printf' * | awk {'print $100"\t"$0'}
	if grep -q "printf" ./*/*.c; then
		NBR=1
	fi
	cat */* | find . -not -path '*/\.*' -iname "*c" -exec zgrep 'printf' {} \; | awk {'print $100 "\t"$0'}


	cat */* | grep --color -rsl 'stdio' * | awk {'print $100"\t"$0'}
	if grep -q "stdio" ./*/*.c; then
		NBR=1
	fi
	cat */* | find . -not -path '*/\.*' -iname "*c" -exec zgrep 'stdio' {} \; | awk {'print $100 "\t"$0'}


	cat */* | grep --color -rsl 'for (' * | awk {'print $100"\t"$0'}
	if grep -q "for" ./*/*.c; then
		NBR=1
	fi
	cat */* | find . -not -path '*/\.*' -iname "*c" -exec zgrep 'for (' {} \; | awk {'print $100 "\t"$0'}

	if [ $NBR == 0 ]
	then
		printf "\n\t\t${WHITE}All files check.${STOP}"
		printf "\n\n${GREEN}\t\t\t\t\t\t\t\t\t\t\t\t- OK √${STOP}\n"
		printf "[=============================================================================================================]\n"

	else
		printf "\n\n${RED}\t\t\t\t\t\t\t\t\t\t\t\t- KO X${STOP}\n"
		printf "[=============================================================================================================]\n"
	fi
}

function norm {
	printf "[=============================================================================================================]\n"
	printf "\n\t${WHITE}${UNDERLINE}--- NORMINETTE ---${STOP}\n\n"

	norminette -R CheckForbiddenSourceHeader | if grep -qEi "Warning|Error"
	then
		norminette -R CheckForbiddenSourceHeader | grep --color -B 100  -Ei 'Warning|Error' | awk {'print $100"\t"$0'}
		printf "\n\n${RED}\t\t\t\t\t\t\t\t\t\t\t\t- KO X${STOP}\n"
		printf "[=============================================================================================================]\n"
	else
		norminette -R CheckForbiddenSourceHeader | awk {'print $5"\t"$0'}
		printf "\n\t\t${WHITE}All files check.${STOP}"
		printf "\n\n${GREEN}\t\t\t\t\t\t\t\t\t\t\t\t- OK √${STOP}\n"
		printf "[=============================================================================================================]\n"
	fi
}

function cmod {
	printf "[=============================================================================================================]\n"
	printf "\n\t${WHITE}${UNDERLINE}--- CHMOD ---${STOP}\n"
	printf "\n$(ls -la */* | awk {'print $5"\t"$0'})\n\n\t\t${WHITE}${INVERTED}%s${STOP}\n\n" "--- [POOL PARTY] ---"
	chmod -x ./*/ft*.c
	printf "$(ls -la */* | awk {'print $5"\t"$0'})\n\n${GREEN}\t\t\t\t\t\t\t\t\t\t\t\t%s${STOP}\n" "- OK √"
	printf "[=============================================================================================================]\n"
}

function check {
if find . \( ! -regex '.*/\..*' \) -type f -mindepth 2 -print -quit 2>/dev/null | grep -q .; then
		sh $BASEDIR/msg.sh
	else
		sh $BASEDIR/msg.sh
		printf "[=============================================================================================================]\n"
		printf "\n\t\t\t\t\t\t${WHITE}Folder is empty${STOP}\n\n"
		printf "[=============================================================================================================]\n"
		printf "\t\t\t\t\t\t${GREEN} [--- FINISH ---]\n"
		exit 0
	fi
}

clear
check
if [ $MOD == 0 ]
then
	cmod
fi
if [ $NORM == 0 ]
then
	norm
fi
forbidden
if [ $COMP == 0 ]
then
	comp
fi
if [ $GIT == 0 ]
then
	git_status
fi

printf "\t\t\t\t\t\t${GREEN} [--- FINISH ---]\n"
exit 0
