#!/bin/bash

function showTables(){
    available_databases=($(ls ./database/$1))
    if [[ ${#available_databases[@]} > 0 ]]
    then
        _db=($(ls ./database/$1))
         printf "Your Table(s) \n "

         for i in "${_db[@]}"
            do
            if ! [[ $i == metaData* ]]
            then
            echo "$i"
            echo "////////////// Table fields ///////////////"
             awk 'BEGIN { FS = ":" ; OFS=" " } {print  $1}' ./database/$1/metaData_$i
            echo "/////////////////////////////////////////////"
            echo "                                                                                                "
            fi
            done
        
    else
       echo "there is no any tables yet !"
        echo " "
     if [[ "$2" = '' ]]
        then
         while true
    do  
        echo "do you want to create a new table??"
        echo "y-yes"
        echo "n-no"
        IFS= read choice
        case $choice in
        y|Y)
        createTable $1
        break;;
        n|N)
        echo "good bye ^_^"
        break
         ;;
        *)
            echo "invalid Option !!! please select again" 
        showTables $1 
             break
            ;;
         esac 
         done
        fi
    fi  
}


