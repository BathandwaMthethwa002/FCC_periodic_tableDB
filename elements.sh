#!/bin/bash

# Check if no argument is provided
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  else
  PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
SYMBOL=$1

# Ensure that the symbol is properly capitalized
SYMBOL=$(echo "$SYMBOL" | awk '{print toupper($0)}')

# Check if input is not a number (atomic number check)
if [[ ! $SYMBOL =~ ^[0-9]+$ ]]; then
  # If input is greater than two letters (assumes name or symbol)
  LENGTH=$(echo -n "$SYMBOL" | wc -m)
  if [[ $LENGTH -gt 2 ]]; then
    # Get data by full name
    DATA=$($PSQL "SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name ILIKE '$SYMBOL'")
    if [[ -z $DATA ]]; then
      echo "I could not find that element in the database."
    else
      # Output formatted data
      echo "$DATA" | while IFS='|' read NUMBER NAME SYMBOL WEIGHT MELTING BOILING TYPE
      do
        # Remove trailing zeros from atomic mass
        WEIGHT=$(echo $WEIGHT | sed 's/\.0*$//')
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    fi
  else
    # Get data by atomic symbol
    DATA=$($PSQL "SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol ILIKE '$SYMBOL'")
    if [[ -z $DATA ]]; then
      echo "I could not find that element in the database."
    else
      # Output formatted data
      echo "$DATA" | while IFS='|' read NUMBER NAME SYMBOL WEIGHT MELTING BOILING TYPE
      do
        # Remove trailing zeros from atomic mass
        WEIGHT=$(echo $WEIGHT | sed 's/\.0*$//')
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    fi
  fi
else
  # Get data by atomic number
  DATA=$($PSQL "SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $SYMBOL")
  if [[ -z $DATA ]]; then
    echo "I could not find that element in the database."
  else
    # Output formatted data
    echo "$DATA" | while IFS='|' read NUMBER NAME SYMBOL WEIGHT MELTING BOILING TYPE
    do
      # Remove trailing zeros from atomic mass
      WEIGHT=$(echo $WEIGHT | sed 's/\.0*$//')
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $WEIGHT amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
fi
fi



