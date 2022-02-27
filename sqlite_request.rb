Dir["./sqlite_request/*.rb"].each {|file| require file }
require 'csv'

class MySqliteRequest

    include Select
    include Update
    include Insert
    include Delete

    def initialize
        @type_of_request    = :none
        @select_columns     = []
        @where_key          = nil
        @where_key_2        = nil
        @where_value        = nil
        @where_value_2      = nil
        @insert_values      = {}
        @update_attributes  = {}
        @table_name         = nil
        @order              = :asc
        @order_column       = nil
        @join_column_db_a   = nil
        @join_column_db_b   = nil
        @second_table_name  = nil
        
    end

    def restart
        initialize
    end
    

    def from(table_name)
        @table_name = table_name
        self
    end

    def where(column_name, criteria)
        if @where_key.nil?
            @where_key      = column_name
            @where_value    = criteria
        elsif @where_key_2.nil?
            @where_key_2      = column_name
            @where_value_2    = criteria
        end
        self
    end

    def run
        if      (@type_of_request == :select)
            print_select
            run_select
        elsif   (@type_of_request == :insert)
            print_insert
            run_insert
        elsif   (@type_of_request == :update)
            print_update
            run_update
        elsif   (@type_of_request == :delete)
            print_delete
            run_delete
        end
    end
end

def _main()
=begin
    #TEST CASE 1 - MYSQLITEREQUEST CLASS - SIMPLE SELECT
    request = MySqliteRequest.new
    request = request.from('nba_player_data.csv')
    request = request.select('name')
    request.run
        ^^ Success

    #TEST CASE 2 - MYSQLITEREQUEST CLASS - SIMPLE SELECT + WHERE
    request = MySqliteRequest.new
    request = request.from('nba_player_data.csv')
    request = request.select('name')
    request = request.where('college', 'University of California')
    request.run
        ^^ Success

    #TEST CASE 3 - MYSQLITEREQUEST CLASS - SIMPLE SELECT + MULTIPLE WHERE
    request = MySqliteRequest.new
    request = request.from('nba_player_data.csv')
    request = request.select('name')
    request = request.where('college', 'University of California')
    request = request.where('year_start', '1997')
    request.run

    #TEST CASE 4 - MYSQLITEREQUEST CLASS - SIMPLE SELECT + WHERE + ORDER
    request = MySqliteRequest.new
    request = request.from('nba_player_data.csv')
    request = request.select('college')
    request = request.where('year_start', '1991')
    request = request.order(:desc, 'college')
    request.run
        ^^ Success

    #TEST CASE 5 - MYSQLITEREQUEST CLASS - SELECT * FROM
    request = MySqliteRequest.new
    request = request.from('nba_player_data_light.csv')
    request = request.select('*')
    request.run
        ^^ Success

    #TEST CASE 6 - MYSQLITEREQUEST CLASS - SIMPLE SELECT + JOIN
    request = MySqliteRequest.new
    request = request.from('nba_player_data_light.csv')
    request = request.select('name')
    request = request.join('name', 'nba_data.csv', 'middle_name')
    request.run
        ^^ Success

    #TEST CASE 7 - MYSQLITEREQUEST CLASS - SIMPLE INSERT
    request = MySqliteRequest.new
    request = request.insert('nba_player_data_light.csv')
    request = request.values({"name" => "Don Adams", "year_start" => "1971", "year_end" => "1977", "position" => "F", "height" =>"6-6", "weight"=>"210", "birth_date"=>"November 27, 1947", "college"=>"Northwestern University"})
    request.run
        ^^ Success

    #TEST CASE 8 - MYSQLITEREQUEST CLASS - SIMPLE UPDATE + SET
    request = MySqliteRequest.new
    request = request.update('nba_player_data_light.csv')
    request = request.set('name' => 'Alaa Renamed')
    request = request.where('name', 'Alaa Abdelnaby')
    request.run
        ^^ Success

    #TEST CASE 9 - MYSQLITEREQUEST CLASS - SIMPLE DELETE + WHERE
    request = MySqliteRequest.new
    request = request.delete()
    request = request.from('nba_player_data_light.csv')
    request = request.where('name', 'Alaa Abdelnaby')
    request.run
        ^^ Success
=end

# request = MySqliteRequest.new
# request = request.delete()
# request = request.from('nba_player_data_light.csv')
# request = request.where('name', 'Don Adams')
# request.run

end

_main