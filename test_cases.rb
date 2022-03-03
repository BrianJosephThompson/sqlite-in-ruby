require_relative 'my_sqlite_cli.rb'

def test_cases
    # TEST CASES MYSQLITEREQUEST CLASS

    #TEST CASE 1 - MYSQLITEREQUEST CLASS - SIMPLE SELECT

    # request = MySqliteRequest.new
    # request = request.from('nba_player_data.csv')
    # request = request.select('name')
    # request.run
    #     ^^ Success

    #TEST CASE 2 - MYSQLITEREQUEST CLASS - SIMPLE SELECT + WHERE

    # request = MySqliteRequest.new
    # request = request.from('nba_player_data.csv')
    # request = request.select('name')
    # request = request.where('college', 'University of California')
    # request.run
    #     ^^ Success

    #TEST CASE 3 - MYSQLITEREQUEST CLASS - SIMPLE SELECT + MULTIPLE WHERE

    # request = MySqliteRequest.new
    # request = request.from('nba_player_data.csv')
    # request = request.select('name')
    # request = request.where('college', 'University of California')
    # request = request.where('year_start', '1997')
    # request.run
    #     ^^ Success


    #TEST CASE 4 - MYSQLITEREQUEST CLASS - MULTIPLE SELECT + WHERE + ORDER

    # request = MySqliteRequest.new
    # request = request.from('nba_player_data.csv')
    # request = request.select('name')
    # request = request.select('college')
    # request = request.where('year_start', '1991')
    # request = request.order(:desc, 'college')
    # request.run
    #     ^^ Success

    #TEST CASE 5 - MYSQLITEREQUEST CLASS - SELECT * FROM

    # request = MySqliteRequest.new
    # request = request.from('nba_player_data.csv')
    # request = request.select('*')
    # request.run
    #     ^^ Success

    #TEST CASE 6 - MYSQLITEREQUEST CLASS - MULTIPLE SELECT + JOIN

    # request = MySqliteRequest.new
    # request = request.from('nba_player_data_light.csv')
    # request = request.select('name')
    # request = request.select('college')
    # request = request.join('name', 'nba_player_data_light_extra_column.csv', 'middle_name')
    # request.run
    #     ^^ Success

    #TEST CASE 7 - MYSQLITEREQUEST CLASS - SIMPLE INSERT

    # request = MySqliteRequest.new
    # request = request.insert('nba_player_data_light.csv')
    # request = request.values({"name" => "Don Adams", "year_start" => "1971", "year_end" => "1977", "position" => "F", "height" =>"6-6", "weight"=>"210", "birth_date"=>"November 27, 1947", "college"=>"Northwestern University"})
    # request.run
    #     ^^ Success

    #TEST CASE 8 - MYSQLITEREQUEST CLASS - SIMPLE UPDATE + SET

    # request = MySqliteRequest.new
    # request = request.update('nba_player_data_light.csv')
    # request = request.set('name' => 'Alaa Renamed')
    # request = request.where('name', 'Alaa Abdelnaby')
    # request.run
    #     ^^ Success

    #TEST CASE 9 - MYSQLITEREQUEST CLASS - SIMPLE UPDATE + Multiple SET   

    # request = MySqliteRequest.new
    # request = request.update('nba_player_data_light.csv')
    # request = request.set('year_start' => 'Nineteen Ninety One')
    # request = request.set('year_end' => 'Nineteen Ninety Five')
    # request = request.where('name', 'Alaa Abdelnaby')
    # request.run
    #         ^^ Success

    #TEST CASE 10 - MYSQLITEREQUEST CLASS - SIMPLE DELETE + WHERE

    # request = MySqliteRequest.new
    # request = request.delete()
    # request = request.from('nba_player_data_light.csv')
    # request = request.where('name', 'Alaa Abdelnaby')
    # request.run
    #     ^^ Success

    
    # BE SURE TO COMMENT ALL ABOVE TEST CASES BEFORE INITIATING CLI.
    # ONLY UNCOMMENT THE TWO LINES BELOW TO RUN CLI.

    # cli = MySqliteCli.new
    # cli.scan_cli


    # TEST CASES COMMAND LINE INTERFACE

    # TEST CASE # 1 - SELECT FROM   ->  SELECT name FROM students
    #     ^^ Success

    # TEST CASE # 2 - SELECT FROM *   ->   SELECT * FROM students
    #     ^^ Success

    # TEst CASE # 3 - SELECT MULTIPLE + FROM + WHERE   ->   SELECT name,email FROM students WHERE name = 'Mila'
    #     ^^ Success

    # TEST CASE # 4 - SELECT MULTIPLE + FROM + MULTIPLE WHERE   ->   SELECT name,grade FROM students WHERE name = 'John' grade = 'A'
    #     ^^ Success
    
    # TEST CASE # 5 - SELECT MULTIPLE + FROM NBA TABLE + WHERE  ->   SELECT name,college,year_start,year_end,position,height FROM players WHERE year_start = '1997'
    #     ^^ Success

    # TEST CASE # 6 - SELECT MULTIPLE + FROM + WHERE + ORDER BY   ->   SELECT name,grade FROM students WHERE grade = 'B' ORDER BY name ASC
    #     ^^ Success
    
    # TEST CASE # 7 - SELECT MULTIPLE + FROM + JOIN ON   ->  SELECT name,grade FROM students JOIN others ON students.name = others.favorite_color
    #     ^^ Success

    # TEST CASE # 8 - UPDATE + SET + WHERE    ->  UPDATE students SET email = 'jane@Changedagain.com' WHERE name = 'Mila'
    #     ^^ Success

    # TEST CASE # 9 - UPDATE + MULTIPLE SET + WHERE   ->  UPDATE students SET email = 'jane@janedoe.com', blog = 'https://blog.janedoe.com' WHERE name = 'Mila'
    #     ^^ Success

    # TEST CASE # 10 - INSERT + VALUES    ->  INSERT INTO students VALUES (John,john@johndoe.com,A,https://blog.johndoe.com)
    #     ^^ Success

    # TEST CASE # 11 - DELETE + FROM + WHERE   ->   DELETE FROM students WHERE name = 'John'
    #     ^^ Success
    
    

end


test_cases