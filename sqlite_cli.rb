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


=end


class MySqliteCli

    def initialize
        @valid_commands     = ["SELECT", "INSERT", "UPDATE", "DELETE", "FROM", "WHERE", "JOIN", "ORDER", "VALUES", "SET", "INTO" ,"*"]
        @select_commands    = ["SELECT", ,"*", "FROM", "WHERE", "JOIN", "ORDER"]
        @insert_commands    = ["INSERT", "INTO", "VALUES"]
        @update_commands    = ["UPDATE", "SET", "WHERE"]
        @delete_commands    = ["DELETE", "FROM", "WHERE"]
    end

    def scan_cli(request)
        version_control
        while buf = Readline.readline("my_sqlite_cli> ", true)
            input = buf.split
            # request.restart
            if input[0].upcase == "SELECT"
                run_select_cli(request, input)
            elsif input[0].upcase == "INSERT"
                # run insert cli
            elsif input[0].upcase == "UPDATE"
                # run update cli
            elsif input[0].upcase == "DELETE"
                # run delete cli
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



    def run_select_cli(request, input)

    end

    def run_insert_cli(request, input)

    end

    def run_update_cli(request, input)

    end

    def run_delete_cli(request, input)

    end
end

request = MySqliteRequest.new
cli = MySqliteCli.new
cli.scan_cli(request)