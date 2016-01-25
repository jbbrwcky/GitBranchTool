LGRN='\033[1;32m'
GRN='\033[0;32m'
YLW='\033[1;33m'
ORG='\033[0;33m'
CYN='\033[0;36m'
RED='\033[1;31m'
NC='\033[0m'

function ggo() {
  declare -a brancharray
  j=0

  shopt -s nocasematch
  set -f

  if [ ! -d ".git" ]; then
    echo "This is not a working git repository"
    return 1
  fi

  # Our main command
  output=$(git branch)
  current=$(git rev-parse --abbrev-ref HEAD)

  if ! [ "$1" ]; then
    echo "Usage: ggo <branchname>"
    return 2
  fi

  # While loop but not on STDIN
  while read -r line <&9; do
  {
    if [[ $line == *$1* && $1 ]]; then
      arr=($line)
      let "j += 1"
      if [[ ${arr[1]} ]]; then
        brancharray+=(${arr[1]})
        printf "Match ${RED}$j${NC}: ${CYN}${arr[1]}${NC} (${ORG}current${NC})\n"
      else
        brancharray+=($line)
        printf "Match ${RED}$j${NC}: ${CYN}$line${NC}\n"
      fi
    fi

  }
  done 9<<< "$output"

  set +f

  # LOGIC; No matches?
  if [ "$j" -eq 0 ]; then
    printf "No git branches matching ${RED}$1${NC} found"
    return 3
  fi

  # LOGIC; More than 1 match? Otherwise just 1 match;
  if [ "$j" -gt 1 ]; then
    printf "Input match number (${RED}1${NC} to ${RED}$j${NC}) to switch to that branch: "
    read -r gitbranch
    
    if [ -n $gitbranch ]; then
      if [[ $gitbranch -gt $j || $gitbranch -eq 0 ]]; then
        echo "That is not a valid match number!"
        return 4
      fi

      if [[ -n ${gitbranch//[0-9]/} ]]; then
        echo "Perhaps the word 'number' is too difficult?"
        return 5
      else
        if [[ ${brancharray[$gitbranch-1]} -eq $current ]]; then
          printf "You are already on that branch (${ORG}$current${NC})"
	  return 6
	fi

        printf "Switching to git branch '${CYN}${brancharray[$gitbranch-1]}${NC}'"
        git checkout -q ${brancharray[$gitbranch-1]}
        return 7
      fi
    else
      echo "It's only a number, not that difficult..."
      return 8
    fi

  else
    printf "Switching to git branch '${CYN}${brancharray[0]}${NC}'"
    git checkout -q ${brancharray[0]}
  fi
}
