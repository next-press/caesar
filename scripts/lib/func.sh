# set -Exeuo pipefail

if ! [ -n "$INSTALL_TYPE" ]; then
  INSTALL_TYPE="subdir"
fi

if [ "$INSTALL_TYPE" == "subdomain" ]; then
  INSTALL_TYPE="subdomain"
elif [ "$INSTALL_TYPE" == "single" ]; then
  INSTALL_TYPE="single"
else
  INSTALL_TYPE="subdir"
fi

${LIB_PATH}/scripts/lib/add-or-replace "$CWD_PATH/.env" "INSTALL_TYPE" $INSTALL_TYPE

# function called by trap
function pd {
  echo "";
  echo "→ $1"
}

function pdns {
  echo "→ $1"
}

other_commands() {
  pd "Process interrupted"
  exit 1
}

trap 'other_commands' SIGINT

function check_status {

  if ! test -f "$CWD_PATH/.status"; then
    return 1
  fi

  cat "$CWD_PATH/.status" | grep $1 2>&1 /dev/null

  if ! [ $? -eq 0 ]; then
    return 1;
  fi

}

function touch_status {

  if test -f "$CWD_PATH/.status"; then

    check_status $1

    if [ $? -eq 0 ]; then
      echo >> "$CWD_PATH/.status"
      echo $1 >> "$CWD_PATH/.status"
    fi
  
  else

    touch "$CWD_PATH/.status"
    echo "# Remove the items below if you need to re-run them." >> "$CWD_PATH/.status"

  fi

}

# Author: Tasos Latsas

# spinner.sh
#
# Display an awesome 'spinner' while running your long shell commands
#
# Do *NOT* call _spinner function directly.
# Use {start,stop}_spinner wrapper functions

# usage:
#   1. source this script in your's
#   2. start the spinner:
#       start_spinner [display-message-here]
#   3. run your command
#   4. stop the spinner:
#       stop_spinner [your command's exit status]
#
# Also see: test.sh

function _spinner() {
    # $1 start/stop
    #
    # on start: $2 display message
    # on stop : $2 process exit status
    #           $3 spinner function pid (supplied from stop_spinner)

    local on_success="→ Done"
    local on_fail="→ Fail"
    local white="$(tput setaf 5)"
    local green="$(tput setaf 2)"
    local red="$(tput setaf 1)"
    local nc="$(tput setaf 7)"

    case $1 in
        start)

            TEXT="$(tput setaf 4)ー ${2}$(tput setaf 7)"

            # calculate the column where spinner and status msg will be displayed
            let column=$(tput cols)-${#TEXT}

            # display message and position the cursor in $column column
            # echo -ne "\e[1;30mー Lionel \e[0m"
            echo -ne $TEXT

            printf "%${column}s"

            # start spinner
            i=1
            sp='\|/-'
            delay=${SPINNER_DELAY:-0.15}

            while :
            do
                printf "\b${sp:i++%${#sp}:1}"
                sleep $delay
            done
            ;;
        stop)
            if [[ -z ${3} ]]; then
                # echo "spinner is not running.."
                exit 1
            fi

            kill $3 > /dev/null 2>&1

            # inform the user uppon success or failure
            echo -en "\b["
            if [[ $2 -eq 0 ]]; then
                echo -en "${green}${on_success}${nc}"
            else
                echo -en "${red}${on_fail}${nc}"
            fi
            echo -e "]"
            ;;
        *)
            echo "invalid argument, try {start/stop}"
            exit 1
            ;;
    esac
}

function start_spinner {
    # $1 : msg to display
    _spinner "start" "${1}" &
    # set global spinner pid
    _sp_pid=$!
    disown
}

function stop_spinner {
    # $1 : command exit status
    _spinner "stop" $1 $_sp_pid
    unset _sp_pid
}


function box_out()
{
  local s=("$@") b w
  for l in "${s[@]}"; do
    ((w<${#l})) && { b="$l"; w="${#l}"; }
  done
  tput setaf 7
  echo "${b//?/▁}"
  for l in "${s[@]}"; do
    printf '▏ %s%*s%s\n' "$(tput setaf 7)" "-$w" "$l" "$(tput setaf 7)"
  done
  echo "${b//?/▔}"
  tput sgr 0
}

function __log() {

  mkdir ~/.caesar/logs > /dev/null 2>&1
  
  touch ~/.caesar/logs/$1.log > /dev/null 2>&1

  echo $2 >> ~/.caesar/logs/$1.log > /dev/null 2>&1

}
