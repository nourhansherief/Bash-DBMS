#!/bin/bash
. "./createNewDB.sh"
. "./useDB.sh"
. "./showDatabases.sh"
. "./deleteDB.sh"
function WelcomeToOurDb()
{
echo "Welcome to Amal & Nourhan DataBase engine" 
echo "Follow the instructions please  ^_^ "
echo "Be Carful with using spaces with database names "
echo "Be Carful with using spaces with database columns"
while true
do

echo "======= Here the menu  ================="
echo "c-create new database"
echo "u-use database"
echo "s-show available database"
echo "d-delete datbase"
echo "l-leave Us"

 IFS= read -p "please enter character: " input

case $input in
c|C)
  	createNewDB ;;
u|U)
	useDataBase ;;
s|S)
	#echo "show databases";;
	showDatabases ;;
d|D)
	#echo "d" ;;
	deleteDB ;;
l|l)
echo "l"
break ;;
*)
  echo "invalid Option !!! please select again" ;;
esac
done }
WelcomeToOurDb;



