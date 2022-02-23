
require 'csv'

class MySqliteRequest

    def initialize
        @type_of_request    = :none
        @select_columns     = []
        @where_column       = nil
        @where_value        = nil
        @insert_attributes  = {}
        @update_attributes  = {}
        @table_name         = nil
        @order              = :asc
        
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
        @where_column   = column_name
        @where_value    = criteria
        self
    end

    def join(col_a, file_b, col_b)
        result = []
        CSV.parse(File.read(@table_name), headers: true).collect do |row|
            result << row
        end
    
        CSV.parse(File.read(file_b), headers: true).collect do |row|
            entry = result.select { |entry| entry[col_a] == row[col_a] }.first
            entry[col_b] = row[col_b]
        end

        p result
        self
    end

    def order(order, column_name)
        @order = order
        if (@order == :asc)
            p _sort_order(column_name)
        elsif (@order == :desc)
            p _sort_order(column_name).reverse!
        end
        self
    end

    def insert(table_name)
        @table_name = table_name
        self._setTypeOfRequest(:insert)
        self
    end

    def values(data)
        if (@type_of_request == :insert)
            @insert_attributes = data
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
        puts "type of request #{@type_of_request}"
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
        if (@where_params)
            puts "WHERE #{@where_column} = #{@where_value}"
        end
    end

    def print_insert_type
        puts "INSERT INTO #{@table_name}"
        puts "INSERT #{@insert_attributes}"
    end

    def print_update_type
        puts "UPDATE #{@table_name}"
        puts "SET #{@update_attributes}"
        if (@where_column)
            puts "WHERE #{@where_column} = #{@where_value}"
        end
    end

    def print_delete_type
        puts "DELETE FROM #{@table_name}"
        if (@where_column)
            puts "WHERE #{@where_column} = #{@where_value}"
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
            if row[@where_column] == @where_value
                    result << row.to_hash.slice(*@select_columns)
            end
        end
        result
    end

    def _run_insert
        File.open(@table_name, 'a') do |f|
            f.puts @insert_attributes.values.join(',')
        end
    end

    def _run_update        
        csv = CSV.read(@table_name, headers: true)
        csv.each do |row|
            if row[@where_column] == @where_value
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
            row[@where_column] == @where_value
        end
        _update_file(csv)
    end

    def _sort_order(column_name)
        result = []
        CSV.parse(File.read(@table_name), headers: true).collect do |row|
            result << row.to_hash.slice(column_name)
        end
        result.sort_by! {|key| key[column_name] }
    end
    





end

def _main()
=begin
    request = MySqliteRequest.new
    request = request.from('nba_player_data.csv')
    request = request.select('name')
    request = request.where('year_start', '1991')
    p request.run

    request = MySqliteRequest.new
    request = request.insert('nba_player_data_light.csv')
    request = request.values({"name" => "Don Adams", "year_start" => "1971", "year_end" => "1977", "position" => "F", "height" =>"6-6", "weight"=>"210", "birth_date"=>"November 27, 1947", "college"=>"Northwestern University"})
    request.run

    request = MySqliteRequest.new
    request = request.from('nba_player_data_light.csv')
    request = request.order(:desc, 'year_start')
    REVISIT ME

    request = MySqliteRequest.new
    request = request.update('nba_player_data_light.csv')
    request = request.set('name' => 'Alaa Renamed')
    request = request.where('name', 'Alaa Abdelnaby')
    request.run
=end

    request = MySqliteRequest.new
    request = request.delete()
    request = request.from('nba_player_data_light.csv')
    request = request.where('name', 'Alaa Abdelnaby')
    request.run

end

_main