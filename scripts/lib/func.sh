# set -Exeuo pipefail

function pd {
  echo "";
  echo "→ $1"
}

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