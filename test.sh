args=""

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
      ./test.sh $args
      local out=$?
      if [ "0" -eq $out ]
      then
        ((successes++))
      elif [ "1" -eq $out ] 
      then
        ((failures++))
      elif [ "2" -eq $out ]
	  then
	  	echo "Skipped"
	  	((skipped++))
	  fi
    else 
      echo "Skipped"
      ((skipped++))
    fi
    echo ""
    cd ..
  done

  echo "Test suites : $# | Skipped : $skipped | Successful : $successes | Failed : $failures"

  if [[ $* == *--all* ]]
  then 
	noop
  else
  	echo "Skipped some tests, to enable them add the '--all' flag"
  fi
}

if [[ $* == *--all* ]]
then
	args="--all"
fi
test $(ls -d */ | cat)
