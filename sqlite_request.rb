
require 'csv'

class MySqliteRequest

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

    def from(table_name)
        @table_name = table_name
        self
    end

    def select(column_name)
        if (column_name.is_a?(Array))
            @select_columns += column_name.collect { |var| var.to_s }
        else
            @select_columns << column_name.to_s
        end
        self._setTypeOfRequest(:select)
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

    def join(col_a, file_b, col_b)
        @join_column_db_a   = col_a
        @join_column_db_b   = col_b
        @second_table_name  = file_b
        # result = []
        # CSV.parse(File.read(@table_name), headers: true).collect do |row|
        #     result << row
        # end
    
        # CSV.parse(File.read(file_b), headers: true).collect do |row|
        #     entry = result.select { |entry| entry[col_a] == row[col_a] }.first
        #     entry[col_b] = row[col_b]
        # end

        # p result
        self
    end

    def order(order, column_name)
        @order_column = column_name
        @order = order
        self
    end

    def insert(table_name)
        @table_name = table_name
        self._setTypeOfRequest(:insert)
        self
    end

    def values(data)
        if (@type_of_request == :insert)
            @insert_values = data
        else
            raise "VALUES corresponds with INSERT Query"
        end
    self
    end

    def update(table_name)
        @table_name = table_name
        self._setTypeOfRequest(:update)
        self
    end

    def set(data) 
        if (@type_of_request == :update)
            @update_attributes = data
        else
            raise "SET corresponds with UPDATE Query"
        end
    self
    end

    def delete
        self._setTypeOfRequest(:delete)
        self
    end

    def run
        print
        if      (@type_of_request == :select)
            _run_select
        elsif   (@type_of_request == :insert)
            _run_insert
        elsif   (@type_of_request == :update)
            _run_update
        elsif   (@type_of_request == :delete)
            _run_delete
        end

    end

    def print
        if      (@type_of_request == :select)
            print_select_type
        elsif   (@type_of_request == :insert)
            print_insert_type
        elsif   (@type_of_request == :update)
            print_update_type
        elsif   (@type_of_request == :delete)
            print_delete_type
        end
    end

    def print_select_type
        puts "SELECT #{@select_columns}"
        puts "FROM #{@table_name}"
        if (@where_key)
            puts "WHERE #{@where_key} = #{@where_value}"
        end
        if (@where_key_2)
            puts "WHERE #{@where_key_2} = #{@where_value_2}"
        end
        if (@join_column_db_a and @join_column_db_b and @second_table_name)
            puts "JOIN #{@second_table_name} ON #{@table_name}.#{@join_column_db_a}=#{@second_table_name}.#{@join_column_db_b}"
        end
        if (@order_column)
            if (@order == :desc)
                puts "ORDER BY #{@order_column} DESC"
            else
                puts "ORDER BY #{@order_column} ASC"
            end
        end
    end

    def print_insert_type
        puts "INSERT INTO #{@table_name}"
        puts "INSERT #{@insert_values}"
    end

    def print_update_type
        puts "UPDATE #{@table_name}"
        puts "SET #{@update_attributes}"
        if (@where_key)
            puts "WHERE #{@where_key} = #{@where_value}"
        end
    end

    def print_delete_type
        puts "DELETE FROM #{@table_name}"
        if (@where_key)
            puts "WHERE #{@where_key} = #{@where_value}"
        end
    end
    

    def _setTypeOfRequest(new_type)
        if (@type_of_request == :none or @type_of_request == new_type)
            @type_of_request = new_type
        else
            raise "Invalid: type of request already set to #{@type_of_request} (new type => #{new_type}"
        end
    end

    def _run_select
        result = []
        csv = CSV.parse(File.read(@table_name), headers: true)
        csv.each do |row|
            if @select_columns[0] == '*'
                result << row.to_hash
            elsif @where_key_2.nil? and @where_key
                if row[@where_key] == @where_value
                    result << row.to_hash.slice(*@select_columns)
                end
            elsif @where_key and @where_key_2 and @where_value and @where_value_2
                if row[@where_key] == @where_value and row[@where_key_2] == @where_value_2
                    result << row.to_hash.slice(*@select_columns)
                end
            elsif !@where_key and !@where_value and !@join_column_db_a
                result << row.to_hash.slice(*@select_columns)
            elsif @join_column_db_a and @join_column_db_b and @second_table_name
                result << row.to_hash
            end
        end
        _run_join(result)
        order_check(result)
        p result
    end

    def _run_join(result)
        if @join_column_db_a and @join_column_db_b and @second_table_name
        
            CSV.parse(File.read(@second_table_name), headers: true).collect do |row|
                entry = result.select { |entry| entry[@join_column_db_a] == row[@join_column_db_a] }.first
                entry[@join_column_db_b] = row[@join_column_db_b]
            end
        end
        result
    end


    def _run_insert
        File.open(@table_name, 'a') do |f|
            f.puts @insert_values.values.join(',')
        end
    end

    def _run_update        
        csv = CSV.read(@table_name, headers: true)
        csv.each do |row|
            if row[@where_key] == @where_value
                @update_attributes.each do |key, value|
                row[key] = value
                end
            end
        end
        _update_file(csv)
    end

    def _update_file(csv)
        File.open(@table_name, 'w+') do |file|
            index = 0
            csv.each do |row|
                if index == 0
                    file << csv.headers.join(',') + "\n"
                end
                file << row
                index += 1
            end
        end
    end

    def _run_delete
        csv = CSV.read(@table_name, headers: true)
        csv.delete_if do |row|
            row[@where_key] == @where_value
        end
        _update_file(csv)
    end

    def order_check(result)
        if (@order == :asc and @order_column)
            result.sort_by! { |key| key[@order_column].to_s }
        elsif (@order == :desc and @order_column)
            result.sort_by! { |key| key[@order_column].to_s }.reverse!
        end
        result        
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



end

_main