#!/bin/bash 

function deleteRow() {
    found=0
     selectValues=$(awk 'BEGIN {FS=":"} {print $1}' ./database/$1/$2)
    # echo ".........."
     # echo $selectValues
     if [[ "$selectValues" != "" ]]
     then
     echo "enter the value of your primary key : " 
     IFS= read  primaryKeyvalue
        #if [["${primaryKeyvalue:-0}" -ge 2 && $primaryKeyvalue != ]
            #then
            for i in $selectValues
                do        
                if [ "$i" == "$primaryKeyvalue" ]
                    then
                    found=1
                    break
                    else
                    found=0
                fi
            done
      #  fi
        if [ -z "$primaryKeyvalue" ]
        then
           echo "Empty value,please try again!!"
          deleteRow "$1" "$2"
        elif [ $found = 0 ]
         then 
         echo  "please select a valid option"
        deleteRow "$1" "$2"
        else
            recordToDelete=$(awk -v  numm=1 -v col_value=$primaryKeyvalue 'BEGIN{ FS = ":"}{ if( $numm == col_value ){ print $0 } }' ./database/$1/$2)
            if [[ $recordToDelete != "" ]]
            then
                sed -i "/$recordToDelete/d"  ./database/$1/$2
                echo "the row is successfuly deleted"
            else
                    echo "you don't have this primary key !!!!"
                
            fi
        fi
        else
            echo "your database is empty"
        fi

}