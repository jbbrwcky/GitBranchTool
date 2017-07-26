#!/bin/bash

for file in "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/../lib/*; do source $file; done

# bash command 'ggo'
# accepts one argument, which it searches for in the git branches you
# have open;
function ggo() {
  declare -a brancharray
  j=0

  shopt -s nocasematch
  set -f

  if [ ! -d "$(git rev-parse --show-toplevel)/.git" ]; then
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
        printf "Match ${COLOUR_RED}$j${COLOUR_NONE}: ${COLOUR_CYAN}${arr[1]}${COLOUR_NONE} (${COLOUR_ORANGE}current${COLOUR_NONE})\n"
      else
        brancharray+=($line)
        printf "Match ${COLOUR_RED}$j${COLOUR_NONE}: ${COLOUR_CYAN}$line${COLOUR_NONE}\n"
      fi
    fi

  }
  done 9<<< "$output"

  set +f

  # LOGIC; No matches?
  if [ "$j" -eq 0 ]; then
    printf "No git branches matching ${COLOUR_RED}$1${COLOUR_NONE} found"
    return 3
  fi

  # LOGIC; More than 1 match? Otherwise just 1 match;
  if [ "$j" -gt 1 ]; then
    printf "Input match number (${COLOUR_RED}1${COLOUR_NONE} to ${COLOUR_RED}$j${COLOUR_NONE}) to switch to that branch: "
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
          printf "You are already on that branch (${COLOUR_ORANGE}$current${COLOUR_NONE})"
     return 6
fi

        printf "Switching to git branch '${COLOUR_CYAN}${brancharray[$gitbranch-1]}${COLOUR_NONE}'"
        git checkout -q ${brancharray[$gitbranch-1]}
        return 7
      fi
    else
      echo "It's only a number, not that difficult..."
      return 8
    fi

  else
    printf "Switching to git branch '${COLOUR_CYAN}${brancharray[0]}${COLOUR_NONE}'"
    git checkout -q ${brancharray[0]}
  fi
}
ggo $@
