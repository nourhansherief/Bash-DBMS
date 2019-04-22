#!/bin/bash

. "./deleteRow.sh"
. "./selectRow.sh"
. "./updateRow.sh"
function checkDataType()
{
    
    echo "enter the new value of $1"
    read val
  
    if [[ "$2" = integer ]]
    then
      # if [[ "$val" =~ ^[0-9]+$  ]]
       #if ! [[ $val =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]
       if [[ "$val" =~ ^[0-9]+$  || "$val" =~ ^$ ]]
        then
         checkFirstConstraint "$val" $3 $4 $5 $6 $7 $2 $1 $8
       else
        echo "your data type is intger , enter integers only please !!!"
        checkDataType $1 $2 $3 $4 $5 $6 $7 $8
       fi
    fi

    if [[ "$2" = varchar ]]
    then
     # if [[ "$val" =~ ^[a-zA-Z0-9\s]+$ ]]
      #if ! [[ $val =~ ^[a-zA-Z]+$ ]]
      if [[ "$val" =~ ^[_a-zA-Z]+ || "$val" =~ ^$ ]]
       then
        
        checkFirstConstraint "$val" $3 $4 $5 $6 $7 $2 $1 $8
        
      else
        echo "your data type is varchar , enter varchars only please !!!"
        checkDataType $1 $2 $3 $4 $5 $6 $7 $8
      fi
    fi
    if [[ "$2" = boolean ]]
    then
      if [[ "$val" = 0 || "$val" = 1 ||  "$val" = true  || "$val" = false || "$val" =~ ^$ ]]
       then
        
       checkFirstConstraint "$val" $3 $4 $5 $6 $7 $2 $1 $8
       
      else
         echo "your data type is boolean , enter boolean values only please !!!"
        checkDataType $1 $2 $3 $4 $5 $6 $7 $8
      fi
    fi
}
function checkFirstConstraint()
{
 
   
    # if [[ -n "$7" ]]
    #     then
    #     found=$7
    #     else
    #     found=1  
    # fi
    found=1
    cfound=1
    if [[ "$2" = "pk" ]]
        then
       # echo "here"
           if [[ "$1" != "" ]]
            then
                pkValues=$(awk 'BEGIN {FS=":"} {print $1}' ./database/$4/$5)
                    if [[ $pkValues = "" ]]
                    then
                     if [[ "$9" = '' ]]
                    then
                    echo -n "$1" >> ./database/$4/$5
                    echo -n ":" >> ./database/$4/$5
                    fi
                    else
                        for i in $pkValues
                            do
                         
                            if [ "$i" == "$1" ]
                                then
                                echo "primary key must be unique"
                                checkDataType $8 $7 $2 $3 $4 $5 $6 $9
                               # checkDataType $1 $2 $3 $4 $5 $6 $found
                                found=1
                                break
                                # break
                            else
                                found=0
                            # echo "jjjjjjjjjjjjjj"
                            #     echo -n "$1" >> ./database/$4/$5
                            #     echo -n ":" >> ./database/$4/$5
                            #     # break
                            fi
                        done
                         if [[ $found = 0 ]]
                            then
                              if [[ "$9" = '' ]]
                                then
                                echo -n "$1" >> ./database/$4/$5
                                echo -n ":" >> ./database/$4/$5
                                fi
                         
                        fi
                    fi
            else
                echo "primary key mustn't be null"
                checkDataType $8 $7 $2 $3 $4 $5 $6 $9
            fi
    elif [[ "$2" = "unique" ]]
    then
       # echo "check for unique"
        #echo $6
           # if [["$1" = '']]
            if [[ "$1" != "" ]]
            then
            colValues=$(awk -v col=$6 'BEGIN { FS = ":" } {print $col}' ./database/$4/$5)
            if [[ $colValues = "" ]]
              then
            #    echo -n "$1" >> ./database/$4/$5
            #    echo -n ":" >> ./database/$4/$5
               checkSecondConstraint "$1" $2 $3 $4 $5 $6 $7 $8 $9
            else
              for i in $colValues
                    do
                    if [ "$i" == "$1" ]
                        then
                        echo "column value must be unique"
                           checkDataType $8 $7 $2 $3 $4 $5 $6 $9
                         cfound=1
                         break
                    else
                    cfound=0
                        #echo -n "$1" >> ./database/$4/$5
                        #echo -n ":" >> ./database/$4/$5
                    fi
                done
                  if [[ $cfound = 0 ]]
                    then
                    checkSecondConstraint "$1" $2 $3 $4 $5 $6 $7 $8 $9
                fi
            fi
        else
            checkSecondConstraint "$1" $2 $3 $4 $5 $6 $7 $8 $9
        fi
    elif [[ "$2" = "notNull" ]]
    then
        if [[ "$1" = "" ]]
            then
            echo "error ! must be not null"
           checkDataType $8 $7 $2 $3 $4 $5 $6 $9
        else
     
        checkSecondConstraint "$1" $2 $3 $4 $5 $6 $7 $8 $9
        fi
    else
      if [[ "$1" != "" ]]
            then
            if [[ "$9" = '' ]]
                then
                echo -n "$1" >> ./database/$4/$5
                echo -n ":" >> ./database/$4/$5
                fi
        else
        if [[ "$9" = '' ]]
            then
            echo -n ":" >> ./database/$4/$5
            fi
         
        fi
    fi
}
function checkSecondConstraint()
{
   
    found=1
    cfound=1
      if [[ "$3" = "unique" ]]
    then
        #echo "check for unique"
        #echo $6
         if [[ "$1" != "" ]]
            then
            colValues=$(awk -v col=$6 'BEGIN { FS = ":" } {print $col}' ./database/$4/$5)
            if [[ $colValues = "" ]]
              then
            #    echo -n "$1" >> ./database/$4/$5
            #    echo -n ":" >> ./database/$4/$5
            
           if [[ "$9" = '' ]]
                then
                echo -n "$1" >> ./database/$4/$5
                echo -n ":" >> ./database/$4/$5
                fi
            else
              for i in $colValues
                    do
                    if [ "$i" == "$1" ]
                        then
                        echo "column value must be unique"
                      checkDataType $8 $7 $2 $3 $4 $5 $6 $9
                         cfound=1
                         break
                    else
                    cfound=0
                        #echo -n "$1" >> ./database/$4/$5
                        #echo -n ":" >> ./database/$4/$5
                    fi
                done
                  if [[ $cfound = 0 ]]
                    then
                  if [[ "$9" = '' ]]
                then
                echo -n "$1" >> ./database/$4/$5
                echo -n ":" >> ./database/$4/$5
                fi
                fi
            fi
     else
            checkSecondConstraint "$1" $2 $3 $4 $5 $6 $7 $8 $9
        fi
    elif [[ "$3" = "notNull" ]]
    then
        if [[ "$1" = "" ]]
            then
            echo "error ! must be not null"
           checkDataType $8 $7 $2 $3 $4 $5 $6 $9
        else
         if [[ "$9" = '' ]]
                then
                echo -n "$1" >> ./database/$4/$5
                echo -n ":" >> ./database/$4/$5
                fi
        fi
    else
       if [[ "$1" != "" ]]
            then
    if [[ "$9" = '' ]]
                then
                echo -n "$1" >> ./database/$4/$5
                echo -n ":" >> ./database/$4/$5
                fi
        else
        if [[ "$9" = '' ]]
                then
                echo -n ":" >> ./database/$4/$5
                fi
        fi
    fi
    
}

###############################################
function insertRow()
{
  rows=$(awk 'BEGIN {FS=":"} {
      print $0
    }' ./database/$1/metaData_$2)
        colNumber=0
      for x in $rows
        do
        ((colNumber++))
        columnValue=$(echo "$x" | cut -d ":" -f 1)
        dataType=$(echo "$x" | cut -d ":" -f 2)
        firstConstraint=$(echo "$x" | cut -d ":" -f 3)
        secondConstraint=$(echo "$x"| cut -d ":" -f 4)
        if [[ -n "$firstConstraint" ]]
        then
        firstConstraint=$firstConstraint
        else
        firstConstraint=0   
        fi
         if [[ -n "$secondConstraint" ]]
        then
        secondConstraint=$secondConstraint
        else
        secondConstraint=0   
        fi
        checkDataType $columnValue $dataType $firstConstraint $secondConstraint $1 $2 $colNumber
       
        done
        echo "Congrats!!!!! your record has been inserted successfully!"
            # num= cat ./database/$1/$2 | wc -l
             #rowFields=$(awk '{if (NR==$num)print $0}' ./database/$1/$2)
            #echo "Data inserted is";
            #for x in $rowFields
            #do
            #echo $x
            #done
        truncate -s-1 ./database/$1/$2
        echo -e "" >> ./database/$1/$2
}

function tablechoices(){
    echo "You select: $2"
    while true
    do
        #echo "You select: $2" 
        echo "Follow the instructions please  ^_^ "
       
        echo "======= Here the menu  ================="
        echo "i-Insert row"
        echo "s-Select row"
        echo "d-Delete row"
        echo "u-Update row"
        echo "b-Back"

         IFS= read -p "please enter character/s: " input

        case $input in
            i|I)
                insertRow "$1" "$2"
            ;;
            s|S)
                selectRow "$1" "$2"
            ;;
            d|D)
                deleteRow "$1" "$2"
                ;;

            u|U)
                updateRow "$1" "$2"
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

function useTable()
{
     showTables	$1
     available_databases=($(ls ./database/$1))
  if [[ ${#available_databases[@]} > 0 ]]
  then
    echo  "Enter your Table name"
	 IFS= read tableName
        if [ -z "$tableName" ]
        then
           echo "Empty value,please try again!!"
           useTable $1 
        elif ! [[ $tableName =~ ^[_a-zA-Z]+$ ]]
      #  elif ! [[ $DBname =~ [a-zA-Z_][a-zA-Z0-9_]* ]]
		then
		  echo "$tableName is not valid format,please try again!!"
           useTable $1 
        elif ! [[  -f ./database/$1/$tableName ]]
        then
               echo "Your table doesn't exist ,please choose one of the Following tables "
        #useDataBase
        else
            tablechoices "$1" "$tableName"
        fi
    fi


}

