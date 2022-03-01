Dir["./sqlite_cli/*.rb"].each {|file| require file }
require "readline"
require_relative 'my_sqlite_request.rb'

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
        @insert_hash            = {}
        @insert_vals            = nil
        @insert_index           = 0
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
        ^^ Success
    
    TEST CASE # 5 - SELECT * FROM students


    TEST CASE # 6 - SELECT name,email FROM students WHERE name = 'Mila'

=end