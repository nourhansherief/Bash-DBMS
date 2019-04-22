#!/bin/bash

function updateRow() {
    found=0
     selectValues=$(awk 'BEGIN {FS=":"} {print $1}' ./database/$1/$2)
    # echo ".........."
     # echo $selectValues
     if [[ "$selectValues" != "" ]]
     then
    echo "enter the value of your primary key : " 
    IFS= read  primaryKeyvalue
    #read  primaryKeyvalue
     if  [[ $primaryKeyvalue  =~  ^[_0-9a-zA-Z]+$ || $primaryKeyvalue =~ ^$ ]]
            then
    recordToUpdate=$(awk -v  numm=1 -v col_value=$primaryKeyvalue 'BEGIN{ FS = ":"}{ if( $numm == col_value ){ print NR } }' ./database/$1/$2)
    #echo $recordToUpdate
     if [[ $recordToUpdate != "" ]]
    then
        echo "Which field do you want to update?"
        awk 'BEGIN { FS = ":" ; OFS=" " } {print NR "-to edit field " $1":"}' ./database/$1/metaData_$2
        selectValues=$(awk 'BEGIN {FS=":"} {print NR}' ./database/$1/metaData_$2)
        echo "select field : "
        IFS= read selectField
        #echo $selectField
       # if [[ "${selectField:-0}" -ge 2 ]] 
           # then
            if  [[ $selectField =~  ^[0-9]+$ ]]
            then
               # echo "not here"
                for i in $selectValues
                    do        
                    if [ $i == $selectField ]
                        then
                        found=1
                        break
                        else
                        found=0
                    fi
                done
            fi
      # fi

         if [ -z "$selectField" ]
        then
           echo "Empty value,please try again!!"
          updateRow "$1" "$2"
        elif [ $found = 0 ]
         then 
         echo  "please select a valid option"
        updateRow "$1" "$2"
        else
            selectFieldValue=$(awk -F ':' -v lineNo="$selectField"  'NR == lineNo { print $0 }'  OFS=':' ./database/$1/metaData_$2 )
            columnValue=$(echo "$selectFieldValue" | cut -d ":" -f 1)
            dataType=$(echo "$selectFieldValue" | cut -d ":" -f 2)
            firstConstraint=$(echo "$selectFieldValue" | cut -d ":" -f 3)
            secondConstraint=$(echo "$selectFieldValue"| cut -d ":" -f 4)
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
            colNumber=$selectField
            updateFlag=1
            checkDataType $columnValue $dataType $firstConstraint $secondConstraint $1 $2 $colNumber $updateFlag
            recordToSelect=$(awk  -v   numm=1 -v col_value="$columnValue" 'BEGIN{FS = ":"}{ 
                if( $numm == col_value )
                { 
                print $0 }
            }' ./database/$1/metaData_$2)
            c=$(awk -F ':' -v lineNo="$recordToUpdate" -v val="$val" -v field="$selectField" 'NR == lineNo { $field = val }1'  OFS=':' ./database/$1/$2 >temp && mv temp ./database/$1/$2 )
            echo "the row is successfuly updated"
             fi
        else
            echo "you don't have this primary key !!!!"
            updateRow "$1" "$2"
              
        fi  
    else
       echo "wrong format !!!!"
            updateRow "$1" "$2"
              
        fi  
         else
            echo "your database is empty"
        fi
}
        

        