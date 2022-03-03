# SQLite In Ruby

This project is a light recreation of the SQLite database engine. 

## Description

### Part 0

The below methods will be contained within the MySqliteRequest class.

We will do only 1 join and 1 where per request.

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


### Part I

The Command Line Interface (CLI) to your MySqlite class.
It will use readline.

It will accept request with:

SELECT|INSERT|UPDATE|DELETE
FROM
WHERE (max 1 condition)
JOIN ON (max 1 condition) 
ORDER BY (max 1 condition)

## Part 0 - Steps to test

0. In test.rb uncomment the test cases one by one to test.
1. Enter `ruby test_cases.rb` in command line to test.
2. Re-comment each test case as you progress.

## Part I - Steps to test

0. Uncomment the below in test_cases.rb.
```
cli = MySqliteCli.new
cli.scan_cli

```
1. Enter `ruby test_cases.rb` in command line to test. A new `my_sqlite_cli>` should generate.
2. Copy each test from test_cases.rb into command line interface.
3. Ctrl + C to exit the command line interface.

