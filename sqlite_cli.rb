Dir["./sqlite_cli/*.rb"].each {|file| require file }
require "readline"
require_relative 'my_sqlite_request.rb'

=begin
Valid List of Commands to be Passed to Parser
SELECT|INSERT|UPDATE|DELETE
FROM
WHERE (max 1 condition)
JOIN ON (max 1 condition) Note, you can have multiple WHERE. Yes, you should save and load the database from a file. :-)

    1. Select
        Pass Array and SQLiteRequest to select_cli

    2. Insert

    3. Update

    4. Delete
        Pass Array and SQLiteRequest to delete_cli



=end


class MySqliteCli

    include Select_CLI
    include Update_CLI
    include Insert_CLI
    include Delete_CLI

    def initialize
        @valid_student_columns  = ["name","email","grade","blog"]
        @valid_nba_columns      = ["name","year_start","year_end","position","height","weight","birth_date","college"]
        @valid_commands         = ["SELECT", "INSERT", "UPDATE", "DELETE", "FROM", "WHERE", "JOIN", "ORDER", "VALUES", "SET", "INTO" ,"*"]
        @select_commands        = ["SELECT", "*", "FROM", "WHERE", "JOIN", "ORDER"]
        @insert_commands        = ["INSERT", "INTO", "VALUES"]
        @update_commands        = ["UPDATE", "SET", "WHERE"]
        @delete_commands        = ["DELETE", "FROM", "WHERE"]
        @where_col              = nil
        @where_col_2            = nil
        @where_criteria         = nil
        @where_criteria_2       = nil
        @update_values          = {}
        @request                = nil
        @input                  = nil
        @csv                    = nil
        @run_signal             = nil
    end

    def reset
        initialize
    end

    def scan_cli
        version_control
        while buf = Readline.readline("my_sqlite_cli> ", true)
            @input = buf.split
            @request = MySqliteRequest.new
            # request.restart
            if @input[0].upcase == "SELECT"
                run_select_cli
            elsif @input[0].upcase == "INSERT"
                run_insert_cli
            elsif @input[0].upcase == "UPDATE"
                run_update_cli
            elsif @input[0].upcase == "DELETE"
                run_delete_cli
            else
                puts "Invalid Request. Valid SQL commands are: SELECT, INSERT, UPDATE, or DELETE"
            end
        end
    rescue Interrupt
        puts "Exiting Command Line Interface"
        exit
    end

    def version_control
        get_time = Time.new
        puts "MySQLite version 0.1 #{get_time.year}-#{get_time.month}-#{get_time.day}"
    end

    def clean(data)
        data = data.gsub("'", "").gsub(",", "")
    end


    def run_select_cli
        index = 0
        @input.collect! { |entry| entry = clean(entry) }
        @input.each do |entry|
            puts "#{index} - #{entry}"
            index +=1
        end
    end

    def run_insert_cli
        index = 0
        @input.collect! { |entry| entry = clean(entry) }
        @input.each do |entry|
            puts "#{index} - #{entry}"
            index +=1
        end
    end

    def run_update_cli
        index = 0
        @input.collect! { |entry| entry = clean(entry) }
        @input.each do |entry|
            puts "#{index} - #{entry}"
            index +=1
        end
        validate_update
        if (@run_signal == true)
            @request.update(@csv)
            @update_values.each do |k, v|
                @request.set("#{k}" => "#{v}")
            end
            @request.where(@where_col, @where_criteria)
            @request.run_without_print
        end
        reset
    end

    def validate_update
        validate_csv(@input[1])
        if (@input[2].upcase != 'SET')
            puts "Table name must be followed by SET"
        end
        if (@valid_student_columns.include? @input[3]) == true or (@valid_nba_columns.include? @input[3]) == true and @input[4] == '='
            validate_set(@input[1], @input[3], @input[5])
        end
        if (@valid_student_columns.include? @input[6]) == true or (@valid_nba_columns.include? @input[6]) == true and @input[7] == '='
            validate_set(@input[1], @input[6], @input[8])
        end
        if (@input[6].upcase == 'WHERE' and @input[8] == '=')
            validate_where(@input[1], @input[7])
            @where_criteria = @input[9]
            @run_signal = true
        elsif (@input[6].upcase == 'WHERE' and @input[8] != '=')
            puts "SET criteria = value must be followed by WHERE criteria = value"
        end
        if @input[10]
            if (@input[9].upcase == 'WHERE' and @input[11] == '=')
                validate_where(@input[1], @input[10])
                @where_criteria = @input[12]
                @run_signal = true
            elsif (@input[9].upcase == 'WHERE' and @input[11] != '=')
                puts "SET criteria = value must be followed by WHERE criteria = value"
            end
        end
    end




    def validate_set(table, key, value)
        if table.downcase == 'students'
            if (@valid_student_columns.include? key) == false
                puts "Invalid Column Reference. Check spelling, if column exists"
            else
                @update_values[key] = value
            end
        elsif table.downcase == 'players'
            if (@valid_nba_columns.include? key) == false
                puts "Invalid Column Reference. Check spelling, if column exists"
            else
                @update_values[key] = value
            end
        end
    end

    def run_delete_cli
        @input.collect! { |entry| entry = clean(entry) }
        validate_delete
        if @run_signal == true
            @request.delete()
            @request.from(@csv)
            @request.where(@where_col, @where_criteria)
            @request.run_without_print
        end
        reset
    end

    def validate_delete
        if (@input[1].upcase != 'FROM')
            puts "DELETE must be follwed by FROM"
        end
        validate_csv(@input[2])
        if (@input[3].upcase != 'WHERE')
            puts "Table Name must be followed by WHERE"
        end
        validate_where(@input[2], @input[4])
        if (@input[5] != '=')
            puts "WHERE reference must be followed by ="
        end
        if !@input[6]
            puts "WHERE = must be followed by criteria"
        else
            @where_criteria = @input[6]
            @run_signal = true
        end
    end

    def validate_csv(input)
        if input.downcase == 'students' 
            @csv = './csv_files/students.csv'
        elsif input.downcase == 'players'
            @csv = './csv_files/nba_player_data.csv'
        else
            puts "Invalid table reference, Please refer to README for valid choices"
        end
    end

    def validate_where(table, key)
        if table.downcase == 'students'
            if (@valid_student_columns.include? key) == false
                puts "Invalid Column Reference. Check spelling, if column exists"
            else
                @where_col = key
            end
        elsif table.downcase == 'players'
            if (@valid_nba_columns.include? key) == false
                puts "Invalid Column Reference. Check spelling, if column exists"
            else
                @where_col = key
            end
        end
    end

end

cli = MySqliteCli.new
cli.scan_cli

=begin

    TEST CASES MySqliteCli CLASS

    TEST CASE # 1 - DELETE FROM students WHERE name = 'John'
        ^^ Success

    TEST CASE # 2 - UPDATE students SET email = 'jane@janedoe.com', blog = 'https://blog.janedoe.com' WHERE name = 'Mila'
        ^^ Success

    TEst CASE # 3 - UPDATE students SET email = 'jane@Changedagain.com' WHERE name = 'Mila'
        ^^ Success

    TEST CASE # 4 - INSERT INTO students VALUES (John,john@johndoe.com,A,https://blog.johndoe.com)

    
    TEST CASE # 5 - SELECT * FROM students


    TEST CASE # 6 - SELECT name,email FROM students WHERE name = 'Mila'

=end