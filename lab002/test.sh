#!/bin/bash

colors=()
declare -A matrix

for ((i=1;i<=4;i++)) do
    for ((j=1;j<=4;j++)) do
        matrix[$i,$j]=2
    done
done

matrix[3,3]=4
matrix[2,3]=64
matrix[4,3]=128
matrix[1,1]=8

function print(){
  for ((i=1;i<=4;i++)) do
      for ((j=1;j<=4;j++)) do
        if [ ${matrix[$i,$j]} -eq 0 ]; then 
          printf  '.'
        else
          printf  ${matrix[$i,$j]}
        fi
      done
      echo
  done
}


colors[0]=$(tput sgr0)
colors[1]=$(tput bold)
colors[2]=$(tput setab 1)
colors[4]=$(tput setab 2)
colors[8]=$(tput setab 3)
colors[16]=$(tput setab 4)
colors[32]=$(tput setab 5)
colors[64]=$(tput setab 6)
colors[128]=$(tput setab 7)
colors[256]=$(tput setab 4)
colors[512]=$(tput setab 5)
colors[1024]=$(tput setab 2)
colors[2048]=$(tput rev)

# echo -n "${colors[16]}          ${colors[0]}|"

for ((i=1;i<=21;i++)) do
  for ((j=1;j<=41;j++)) do      
    x=$(((($j - 1)) / 10 + 1))
    y=$(((($i - 1)) / 5 + 1))
    num=${matrix[$y,$x]}

    if [ $(($j % 10)) -eq 1 ]; then
      printf '|'
      continue
    elif [ $((i % 5)) -eq 1 ]; then
      printf '-'
      continue
    elif [ $(($j % 10)) -eq 5 ] && [ $(($i % 5)) -eq 3 ]; then
      # for ((n=1;n<="${#num}";n++)) do
      #   ${1:$i:1}
      #   printf 'j'
      # done
      printf $num

      case ${#num} in
        1)
          ;;
        2) ((j++))
          ;;
        3)  ((j+=2))
          ;;
        esac 
    else
      echo -n "${colors[$num]} ${colors[0]}"
    fi
  done
  echo
done

# blue=$(tput setaf 4)
# normal=$(tput sgr0)

# printf "%40s\n" "${blue}This text is blue${normal}"

print