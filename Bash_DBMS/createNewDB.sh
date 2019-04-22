#!/bin/bash
function createNewDB()
{
    echo  "Enter your database name"
		 IFS= read name
        if ! [[ -d ./database ]]
        then 
            mkdir database
        fi
        if [ -z "$name" ]
        then
           echo "Empty value,please try again!!"
           createNewDB
       elif ! [[ $name =~ ^[_a-zA-Z]+$ ]]
       # elif  [[ $name =~ [a-zA-Z_][a-zA-Z0-9_]* ]]
		then
		  echo "$name is not valid format,please try again!!"
          createNewDB
        elif  [[ -d ./database/$name ]]
        then
            echo "you hava a database with this name , enter new database !!!"
            createNewDB
        elif ! [[ "$name" =~ [A-Za-z] ]]
        then
         echo "$name must has at least one alphabet"
        else
            mkdir ./database/$name
            echo "$name database is created successfully"
            echo "**************************************************"
            echo "*********************N&A************************ "
            echo "**************************************************"
        fi
}
