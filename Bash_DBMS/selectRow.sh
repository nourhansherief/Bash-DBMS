#!/bin/bash 

function selectRow(){
    #echo "select"
    echo "enter the value of your primary key : " 
     IFS= read  primaryKeyvalue


   
    recordToSelect=$(awk  -v   numm=1 -v col_value=$primaryKeyvalue 'BEGIN{FS = ":"}{ 
        if( $numm == col_value )
        { 
           print $0 }
     }' ./database/$1/$2)
    if [[ $recordToSelect != "" ]]
        then
        columns=$(awk -F ':' '{print $1}' ./database/$1/metaData_$2)
        echo "-------------------------------"
        for col in $columns
        do
        echo -n "$col        "
        done
        echo "                 "
        string=$recordToSelect
        #set -f                      # avoid globbing (expansion of *).
        #array=(${string//:/ })
       # array=(`echo $string | sed 's/:/\n/g'`)
        array=($(echo "$string" | tr ':' '\n'))
        #readarray -td, array <<<"$string:"; declare -p array;
    
        for i in "${!array[@]}"
        do
        echo -n "${array[i]}     " 
        done
        echo "--------------------------------"
        echo "                 "
       else
         echo "you don't have record for this primary key !!!!"   
    fi

}