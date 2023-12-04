test () {
  local successes=0
  local failures=0
  local skipped=0

  for d in $@
  do
    echo "== Testing $d =="
    d=${d::-1}
    cd $d
    if [ -f "test.sh" ]
    then
      ./test.sh
      local out=$?
      if [ "0" -eq $out ]
      then
        ((successes++))
      elif [ "1" -eq $out ] 
      then
        ((failures++))
      fi
    else 
      echo "Skipped"
      ((skipped++))
    fi
    echo ""
    cd ..
  done

  echo "Test suites : $# | Skipped : $skipped | Successful : $successes | Failed : $failures"
}

test $(ls -d */ | cat)