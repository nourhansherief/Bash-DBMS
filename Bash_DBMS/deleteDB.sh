#!/bin/bash
function deleteDB(){
    #echo "delete"
    deleteFlag=1
    showDatabases $deleteFlag
 if [[ ${#available_databases[@]} > 0 ]]
    then
     # while true
      #do  
        echo "Please enter the name of the Database you want to delete! "
        IFS= read DBname
        if [ -z "$DBname" ]
        then
           echo "Empty value,please try again!!"
          deleteDB
        elif ! [[ $DBname =~ ^[_a-zA-Z]+$ ]]
        then
          echo "$DBname is not valid format,please try again!!"
          deleteDB 
        elif [ ! -d ./database/$DBname ]
      then
       echo "Database not exists, please enter an existing database! "
      deleteDB
      else
            rm -r ./database/$DBname
            echo "$DBname is deleted"
           # break
       fi
      #done
  fi

}