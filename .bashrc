
LGRN='\033[1;32m'
GRN='\033[0;32m'
YLW='\033[1;33m'
CYN='\033[0;36m'
RED='\033[1;31m'
NC='\033[0m'

function ggo() {
  declare -a brancharray
  j=0

  if [ ! -d ".git" ]; then
    echo "This is not a working git repository"
    return 1
  fi

  if [ "$1" ]; then
    echo "Searching current git branches for '$1'"
  else
    echo "Usage: ggo <branchname>"
    return 2
  fi

  # Our main command
  output=$(git branch)

  # While loop but not on STDIN
  while read -r line <&9; do
  {
    if [[ $line == *$1* && $1 ]]; then
      let "j += 1"
      printf "Match ${RED}$j${NC}: ${CYN}$line${NC}\n"
      brancharray+=($line)
    fi

  }
  done 9<<< "$output"

  # LOGIC; No matches?
  if [ "$j" -eq 0 ]; then
    echo "No matching git branches found"
    return 3
  fi

  # LOGIC; More than 1 match? Otherwise just 1 match;
  if [ "$j" -gt 1 ]; then
    printf "Input match number (${RED}1${NC} to ${RED}$j${NC}) to switch to that branch: "
    read -r gitbranch
    
    if [ $gitbranch ]; then
      if [ $gitbranch -gt $j ]; then
        echo "That is not a valid match number!"
        return 4
      fi
    
      if ! [ $gitbranch -eq $gitbranch 2> /dev/null ]; then
        echo "That is not a match number!"
        return 5
      else
        printf "Switching to git branch '${CYN}${brancharray[$gitbranch-1]}${NC}'"
        git checkout -q ${brancharray[$gitbranch-1]}
        return 6
      fi
    else
      echo "It's only a number, not that difficult..."
      return 7
    fi

  else
    printf "Switching to git branch '${CYN}${brancharray[0]}${NC}'"
    git checkout -q ${brancharray[0]}
  fi
}
