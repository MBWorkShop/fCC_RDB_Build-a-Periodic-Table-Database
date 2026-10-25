#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # if argument is number
  if [[ $1 =~ ^[0-9]{1,3}$ ]]
  then
    ATOMIC_NUMBER=$1
    DB_QUERY_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING (atomic_number) JOIN types USING (type_id) WHERE atomic_number = $ATOMIC_NUMBER")
  
  # if argument is symbol
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    ELEMENT_SYMBOL=$1
    DB_QUERY_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING (atomic_number) JOIN types USING (type_id) WHERE symbol = '$ELEMENT_SYMBOL'")

  # if argument is name
  elif [[ $1 =~ ^[A-Z][a-z]{2,}$ ]]
  then
    ELEMENT_NAME=$1
    DB_QUERY_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING (atomic_number) JOIN types USING (type_id) WHERE name = '$ELEMENT_NAME'")
  fi

  # output
  if [[ -z $DB_QUERY_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    IFS='|' read -r ATOMIC_NUMBER ELEMENT_SYMBOL ELEMENT_NAME ELEMENT_TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS <<< "$DB_QUERY_RESULT"
    echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  fi
fi