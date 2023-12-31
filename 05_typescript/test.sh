input="input.txt"
output="output.txt"

test () {
  local errors=0
  local successes=0
  local failures=0

  if [ -d "node_modules" ]
  then
    : # resume
  else
    echo "node_modules not found, installing..."
    bun i
  fi

  for d in $@
  do
    echo "Testing $d"
    local out="not empty"
    { 
      out=$(bun script.ts $d/$input | diff $d/$output -)
    } || {
      ((errors++))
    }
    { 
      if [ -z $out ]
      then
        ((successes++))
      else 
        ((failures++))
      fi
    } 
  done

  echo "Tested : $# | Successes : $successes/$# | Failures : $failures | Errors : $errors"

  if [ "0" -eq $failures ]
  then 
    exit 0
  else
    exit 1
  fi
}

if [[ $* == *--all* ]]
then 
	test $(ls -d ./test_data/* | cat)
else
	exit 2
fi
