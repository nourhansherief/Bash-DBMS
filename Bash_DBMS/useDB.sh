#!/bin/bash
. "./showDatabases.sh"
. "./displayTables.sh"
. "./deleteTable.sh"
. "./useTable.sh"

function primaryColumnValidations(){
    pkFlag=1
   IFS= read -p "Enter your primary key : " colName
        if [ -z "$colName" ]
    then
    echo "Empty value,please try again!!"
    primaryColumnValidations $1 $2
    elif ! [[ $colName =~ ^[a-zA-Z]+$ ]]
    then
    echo "$colName is not valid format,please try again!!"
    primaryColumnValidations $1 $2
    else
        echo -n $colName >> ./database/$1/$2
        #specifyColumnDataType "$colName"
        #echo "Your datatype of the primary key is integer"
        specifyColumnDataType $colName $1 $2 $pkFlag
       # echo -e -n ":integer" >> ./database/$1/$2
        echo -e ":pk" >> ./database/$1/$2

    fi
}
function columnValidations(){
    
    IFS= read -p "Enter column $i :" input
        if [ -z "$input" ]
    then
    echo "Empty value,please try again!!"
    columnValidations $1 $2
    elif ! [[ $input =~ ^[_a-zA-Z]+$ ]]
    then
    echo "$input is not valid format,please try again!!"
    columnValidations $1 $2
    elif  grep -w "$input" ./database/$1/$2
    then
        echo "already exists"
        columnValidations  $1 $2
    else
      echo -n $input >> ./database/$1/$2
     specifyColumnDataType $input $1 $2
    fi

}

function specifyConstrients()
{

    if [[ -n "$4" ]]
        then
        flagnull=$4
        else
         flagnull=0   
    fi

     if [[ -n "$5" ]]
        then
         flagunique=$5
        else
           flagunique=0
    fi

     #flagnull=0
     #flagunique=0
   while true
    do
        echo "--------------------------"
        echo "for $1 field what constraints you desire ??"
        echo "n-not null"
        echo "u-unique"
        echo "d-done with constraints"
         IFS= read  constraint
        
        case $constraint in
        n|N)
         if [[ $flagnull = 0 ]]
                then
                      echo -e -n ":notNull" >> ./database/$2/$3
                     # $nFlag =1
                     flagnull=1
                else 
                echo "You have already set this constraint before"     
                fi
            ;;
        u|U)
         if [[ $flagunique = 0 ]]
                then
                        echo -e -n ":unique" >> ./database/$2/$3
                    flagunique=1
                else 
                echo "You have already set this constraint before"     
                fi
            ;;
        d|D)
           echo -e "" >> ./database/$2/$3
           break ;;
        *)
            echo "invalid Option !!! please select again" 
            
            specifyConstrients $1 $2 $3 $flagnull $flagunique
             break;
           
            ;;
         esac 
         done
}
function specifyColumnDataType()
{
        echo "User entered value :"$1  
        echo "--------------------------"
        echo "for $1 field what data type you want "
        echo "v-datatype is varchar"
        echo "i-datatype is integer"
        echo "b-datatype is boolean"
         IFS= read  colType
        case $colType in
        v|V)
             echo -e -n  ":varchar" >> ./database/$2/$3
             if [[ "$4" = '' ]]
                then
                specifyConstrients $1 $2 $3
                #echo -n "$1" >> ./database/$4/$5
                #echo -n ":" >> ./database/$4/$5
                fi
            #else
                #specifyConstrients $1 $2 $3 
            ;;
        i|I)
            echo -e -n ":integer" >> ./database/$2/$3
            if [[ "$4" = '' ]]
                then
                specifyConstrients $1 $2 $3
                #echo -n "$1" >> ./database/$4/$5
                #echo -n ":" >> ./database/$4/$5
                fi
            #specifyConstrients $1 $2 $3 
        
            ;;
        b|B)
            echo -e -n ":boolean" >> ./database/$2/$3
            if [[ "$4" = '' ]]
                then
                specifyConstrients $1 $2 $3
                #echo -n "$1" >> ./database/$4/$5
                #echo -n ":" >> ./database/$4/$5
                fi
            #specifyConstrients $1 $2 $3 
            
            ;;
        *)
            echo "invalid Option !!! please select again" 
            specifyColumnDataType $1 $2 $3 $4
            ;;
         esac 
}
function enterColumnNumbers()
{
     IFS= read -p "enter the number of columns : " colNum
     if [ -z "$colNum" ]
    then
    echo "Empty value,please try again!!"
    enterColumnNumbers $1 $2
    elif ! [[ $colNum =~ ^[0-9]+$ ]]
    then
    echo "wrong format"
        enterColumnNumbers $1 $2
    elif [[ $colNum < 2 ]]
    then
    echo "column numbers can not be less than 2"
    else
         for i in $(seq $colNum)
            do
            if [[ i -eq 1 ]]
            then
                primaryColumnValidations $1 metaData_$2

            else
                columnValidations $1 metaData_$2
            fi
        done
        echo "$2 table is created successfully"
        echo "**************************************************"
        echo "*********************N&A************************ "
        echo "**************************************************"
    fi
}
function createTable(){
    ############# create table ############
    echo "create table"
     IFS= read tableName
     if [ -z "$tableName" ]
        then
           echo "Empty value,please try again!!"
           createTable $1
        elif ! [[ $tableName =~ ^[_a-zA-Z]+$ ]]
		then
		  echo "$tableName is not valid format,please try again!!"
          createTable $1
        elif  [[ -f ./database/$1/$tableName ]]
        then
            echo "you hava a table with this name !!!"
            createTable $1
        elif [[ $tableName  == metaData* ]]
        then
            echo "you can not start database with metaData (reserved word)"
        else
             touch ./database/$1/$tableName 
             touch ./database/$1/metaData_$tableName
             enterColumnNumbers $1 $tableName	
        fi
}

function DataBasechoices(){
    echo "You select: $1"
    while true
    do
         
        echo "Follow the instructions please  ^_^ "
       
        echo "======= Here the menu  ================="
        echo "s-Show Tables"
        echo "c-Create Table"
        echo "d-Delete Table"
        echo "u-Use Table"
        echo "b-Back"

         IFS= read -p "please enter character/s: " input

        case $input in
            s|S)
                showTables  "$1"
            ;;
            c|C)
                createTable "$1"
            ;;
            d|D)
                deleteTable "$1"
                ;;

            u|U)
                useTable "$1"
                ;;

        b|B)
            break
            ;;

            *)
            echo "invalid Option !!! please select again"
            ;;
            esac
            done
}
function useDataBase()
{
  showDatabases	
  if [[ ${#available_databases[@]} > 0 ]]
  then
    echo  "Enter your Database name"
	IFS= read DBname
        

        if [ -z "$DBname" ]
        then
           echo "Empty value,please try again!!"
           useDataBase
        elif ! [[ $DBname =~ ^[_a-zA-Z]+$ ]]
      #  elif ! [[ $DBname =~ [a-zA-Z_][a-zA-Z0-9_]* ]]
		then
		  echo "$DBname is not valid format,please try again!!"
           useDataBase
        elif ! [[ -d ./database/$DBname ]]
        then
            echo "Your Database doesn't exist!!"
        useDataBase
        else
            DataBasechoices "$DBname"
        fi
    fi
 
}
