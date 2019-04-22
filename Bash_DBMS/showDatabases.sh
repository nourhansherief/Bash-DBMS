#!/bin/bash
function showDatabases() {
    if ! [[ -d ./database ]]
        then 
            mkdir database
        fi
     available_databases=($(ls ./database))
    if [[ ${#available_databases[@]} > 0 ]]
    then
        _db=($(ls ./database))
        printf "Your DataBase(s) \n "
        echo "${_db[@]} "
    else
        echo "there is no any databases !"
        if [[ "$1" = '' ]]
            then
            while true
        do  
            echo "do you want to create a new db??"
            echo "y-yes"
            echo "n-no"
            IFS= read choice
            case $choice in
            y|Y)
            createNewDB 
            break;;
            n|N)
            echo "good bye ^_^"
            break
            ;;
            *)
                echo "invalid Option !!! please select again" 
            showDatabases
                break
                ;;
            esac 
            done
            fi
       # createNewDB
    fi
}