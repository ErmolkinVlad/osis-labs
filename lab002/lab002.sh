#!/bin/bash

declare -A matrix
declare -A array_of_random
declare -A untouchable
colors=()
untouch_count=1
num_rows=4
num_columns=4
score=0

for ((i=1;i<=num_rows;i++)) do
    for ((j=1;j<=num_columns;j++)) do
        matrix[$i,$j]=0
    done
done

matrix[3,3]=2
matrix[2,3]=2
matrix[4,3]=4
matrix[1,1]=2

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


f1="%$((${#num_rows}+1))s"
f2=" %9s"


function join_by { local IFS="$1"; shift; echo "$*"; }


function print(){
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
        printf $num
        if [ ${#num} -gt 1 ]; then
          ((j += ((${#num} - 1))))
        fi
      else
        echo -n "${colors[$num]} ${colors[0]}"
      fi
    done
    echo
  done
}


function reset_untouch(){
  untouch_count=1
  untouchable=()
}


function random_insert(){
  k=0
  for ((i=1;i<=num_rows;i++)) do
    for ((j=1;j<=num_columns;j++)) do
      if [ ${matrix[$i,$j]} -eq 0 ]; then
        ((k++))
        array_of_random[$k]=matrix[$i,$j]
      fi
    done
  done

  num=$RANDOM
  let "num %= k"
  let "num += 1"
  two_or_four=$(( (( (($RANDOM % 2)) + 1)) * 2))
  ((${array_of_random[$num]}=$two_or_four))
}

function down(){
  reset_untouch
  for ((j=1;j<=num_columns;j++)) do
    for ((i=num_rows;i>=1;i--)) do
      real_i=$i
      if [ $i -eq $num_rows ]; then continue; fi

      while [ ${matrix[$((i + 1)),$j]} -eq 0 ]; do
        matrix[$((i + 1)),$j]=${matrix[$i,$j]}
        matrix[$i,$j]=0
        ((i++))
        if [ $i -ge $num_rows ]; then break; fi
      done

      if [ $i -eq $num_rows ]; then 
        i=$real_i
        continue
      fi

      el_under=${matrix[$(( $i + 1 )),$j]}
      if [ $el_under -eq  ${matrix[$i,$j]} ]; then
        bool=0
        for el in ${untouchable[@]}; do
          if [ $(join_by '' $((i + 1)) $j) = $el ]; then
            bool=1
          fi
        done

        if [ $bool -eq 0 ]; then
          ((score += $((${matrix[$i,$j]} * 2))))
          matrix[$(( $i + 1 )),$j]=$((${matrix[$i,$j]} * 2))
          matrix[$i,$j]=0
          untouchable[$untouch_count]=$(join_by '' $(( $i + 1 )) $j)
          ((untouch_count++))
        fi
      fi
      i=$real_i
    done
  done
}


function up(){
  reset_untouch
  for ((j=1;j<=num_columns;j++)) do
    for ((i=1;i<=num_rows;i++)) do
      real_i=$i
      if [ $i -eq 1 ]; then continue; fi

      while [ ${matrix[$((i - 1)),$j]} -eq 0 ]; do
        matrix[$((i - 1)),$j]=${matrix[$i,$j]}
        matrix[$i,$j]=0
        ((i--))
        if [ $i -le 1 ]; then break; fi
      done

      if [ $i -eq 1 ]; then 
        i=$real_i
        continue
      fi

      el_above=${matrix[$(( $i - 1 )),$j]}
      if [ $el_above -eq  ${matrix[$i,$j]} ]; then
        bool=0
        for el in ${untouchable[@]}; do
          if [ $(join_by '' $((i - 1)) $j) = $el ]; then
            bool=1
          fi
        done

        if [ $bool -eq 0 ]; then
          ((score += $((${matrix[$i,$j]} * 2))))
          matrix[$(( $i - 1 )),$j]=$((${matrix[$i,$j]} * 2))
          matrix[$i,$j]=0
          untouchable[$untouch_count]=$(join_by '' $(( $i - 1 )) $j)
          ((untouch_count++))
        fi
      fi
      i=$real_i
    done
  done
}


function left(){
  reset_untouch
  for ((i=1;i<=num_rows;i++)) do
    for ((j=1;j<=num_columns;j++)) do
      real_j=$j
      if [ $j -eq 1 ]; then continue; fi

      while [ ${matrix[$i,$((j - 1))]} -eq 0 ]; do
        matrix[$i,$((j - 1))]=${matrix[$i,$j]}
        matrix[$i,$j]=0
        ((j--))
        if [ $j -le 1 ]; then break; fi
      done

      if [ $j -eq 1 ]; then 
        j=$real_j
        continue
      fi

      el_left=${matrix[$i,$((j - 1))]}
      if [ $el_left -eq  ${matrix[$i,$j]} ]; then
        bool=0
        for el in ${untouchable[@]}; do
          if [ $(join_by '' $i $((j - 1))) = $el ]; then
            bool=1
          fi
        done

        if [ $bool -eq 0 ]; then
          ((score += $((${matrix[$i,$j]} * 2))))
          matrix[$i,$((j - 1))]=$((${matrix[$i,$j]} * 2))
          matrix[$i,$j]=0
          untouchable[$untouch_count]=$(join_by '' $i $((j - 1)))
          ((untouch_count++))
        fi
      fi
      j=$real_j
    done
  done
}


function right(){
  reset_untouch
  for ((i=1;i<=num_rows;i++)) do
    for ((j=num_columns;j>=1;j--)) do
      real_j=$j
      if [ $j -eq $num_columns ]; then continue; fi

      while [ ${matrix[$i,$((j + 1))]} -eq 0 ]; do
        matrix[$i,$((j + 1))]=${matrix[$i,$j]}
        matrix[$i,$j]=0
        ((j++))
        if [ $j -ge $num_columns ]; then break; fi
      done

      if [ $j -eq $num_columns ]; then 
        j=$real_j
        continue
      fi

      el_right=${matrix[$i,$((j + 1))]}
      if [ $el_right -eq  ${matrix[$i,$j]} ]; then
        bool=0
        for el in ${untouchable[@]}; do
          if [ $(join_by '' $i $((j + 1))) = $el ]; then
            bool=1
          fi
        done

        if [ $bool -eq 0 ]; then
          ((score += $((${matrix[$i,$j]} * 2))))
          matrix[$i,$((j + 1))]=$((${matrix[$i,$j]} * 2))
          matrix[$i,$j]=0
          untouchable[$untouch_count]=$(join_by '' $i $((j + 1)))
          ((untouch_count++))
        fi
      fi
      j=$real_j
    done
  done
}

function is_gameover(){

  result=1
  for ((i=1;i<=num_rows;i++)) do
    for ((j=1;j<=num_columns;j++)) do
      left_neighbour=0
      right_neighbour=0
      up_neighbour=0
      down_neighbour=0
      if [ ${matrix[$i,$j]} -eq 0 ]; then
        result=0
        echo "$result"
        exit
      fi
      if [ $i -ne 1 ]; then
       up_neighbour=${matrix[$(($i - 1)),$j]}
      fi
      if [ $i -ne $num_rows ]; then
       down_neighbour=${matrix[$(($i + 1)),$j]}
      fi
      if [ $j -ne 1 ]; then
       left_neighbour=${matrix[$i,$(($j - 1))]}
      fi
      if [ $j -ne $num_columns ]; then
       right_neighbour=${matrix[$i,$(($j + 1))]}
      fi
      me=${matrix[$i,$j]}
      if [ $me -eq $left_neighbour ] || [ $me -eq $right_neighbour ] || [ $me -eq $up_neighbour ] || [ $me -eq $down_neighbour ]; then
        # echo "$me,($i, $j) - $left_neighbour($i,$(($j - 1))), $right_neighbour($i,$(($j + 1))), $up_neighbour($(($i - 1)),$j), $down_neighbour($(($i + 1)),$j)"
        result=0
        echo "$result"
        exit
      fi
    done
  done
  echo "$result"
}


function wasd(){
  if [ $1 = w ] || [ $1 = a ] || [ $1 = s ] || [ $1 = d ]; then
    case $1 in
      w) up
        ;;
      a) left
        ;;
      s) down
        ;;
      d) right
        ;;    
      *) echo $action
    esac
  fi
}

echo -n "Input your name: "
read user_name
clear

echo $user_name
echo "Score: $score"
print
while :; do
  read -rsn1 action
  clear
  check_matrix=$(join_by ${matrix[@]})
  wasd $action

  if [ $check_matrix != $(join_by ${matrix[@]}) ]; then
    random_insert
  else
    game=$(is_gameover)
    if [ $game -eq 1 ]; then
      echo "Game over"
      echo "User: $user_name : $score" >> "leaderboard.txt"
      exit
    fi
  fi

  echo "User: $user_name"
  echo "Score: $score"
  print
done