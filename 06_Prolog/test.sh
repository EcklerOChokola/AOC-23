input="input.txt"
output="output.txt"

test () {
  local errors=0
  local successes=0
  local failures=0

  for d in $@
  do
    echo "Testing $d"
    local out="not empty"
    { 
      out=$(swipl program.pl $d/$input | diff $d/$output -)
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

test $(ls -d ./test_data/* | cat)
