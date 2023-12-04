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
      out=$(cargo run -q $d/$input 2>/dev/null | diff $d/$output -)
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

}

test $(ls -d ./test_data/* | cat)
