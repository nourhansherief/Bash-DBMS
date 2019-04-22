#!/bin/bash
function deleteTable(){
    #echo "delete"
    deleteFlag=1
    #showDatabases $deleteFlag
    showTables $1 $deleteFlag
 available_databases=($(ls ./database/$1))
if [[ ${#available_databases[@]} > 0 ]]
    then
        echo "Please enter the name of the table you want to delete!" 
         IFS= read tableName

        if [ -z "$tableName" ]
        then
           echo "Empty value,please try again!!"
          deleteTable $1
        elif ! [[ $tableName =~ ^[_a-zA-Z]+$ ]]
        then
          echo "$tableName is not valid format,please try again!!"
          deleteTable $1
        elif [ ! -f ./database/$1/$tableName ]
        then
        echo "Table does not exist, please enter an existing table! "
        deleteTable $1
        else
            rm  ./database/$1/$tableName
          rm  ./database/$1/metaData_$tableName
          echo "$tableName is deleted"
        fi
fi
  
}