# SQLite In Ruby

This project is a light recreation of the SQLite database engine. 

## Description

The below methods will be contained within the MySqliteRequest class.

0. From - The from method is present on each request. From will take a parameter and it will be the name of the table(.csv). 

1. Select - The select method which will take one argument, a string or an array of strings. 

2. Where - The where method takes 2 arguments: column_name and criteria. 

3. Join - The join method will load another table name (filename) and will join both database on a column.

4. Order - The order method will receive two parameters, order (:asc or :desc) and column_name. It will sort depending on the order base on the column_name.

5. Insert - The insert method will receive a table name (filename).

6. Values - The values method will receive data (a hash of data on format (key => value)).

7. Update - The update method will receive a table name (filename).

8. Set - The set method will receive data (a hash of data on format (key => value)). It will perform the update of attributes on all matching rows.

9. Delete - The delete method will set the request to delete all matching rows.

10. Run - The run method will execute the request.

## Getting Started

Please use the command line entry below to import the NBA Player Data csv for testing.

    `wget https://storage.googleapis.com/qwasar-public/nba_player_data.csv`


