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
        @select_result      = []
        
    end

    def from(table_name)
        set_table_name(table_name)
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
            p @select_result
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

    def run_without_print
        if      (@type_of_request == :select)
            run_select
        elsif   (@type_of_request == :insert)
            run_insert
        elsif   (@type_of_request == :update)
            run_update
        elsif   (@type_of_request == :delete)
            run_delete
        end
    end

    def set_table_name(table)
        if table == 'nba_player_data.csv' or table == './csv_files/nba_player_data.csv'
            !@table_name and @table_name = './csv_files/nba_player_data.csv'
            !@second_table_name and @table_name != './csv_files/nba_player_data.csv' and @second_table_name = './csv_files/nba_player_data.csv'
        elsif table == 'nba_player_data_light.csv' or table == './csv_files/nba_player_data_light.csv'
            !@table_name and @table_name = './csv_files/nba_player_data_light.csv'
            !@second_table_name and @table_name != './csv_files/nba_player_data_light.csv' and @second_table_name = './csv_files/nba_player_data_light.csv'
        elsif table == 'nba_player_data_light_extra_column.csv' or table == './csv_files/nba_player_data_light_extra_column.csv'
            !@table_name and @table_name = './csv_files/nba_player_data_light_extra_column.csv'
            !@second_table_name and @table_name != './csv_files/nba_player_data_light_extra_column.csv' and @second_table_name = './csv_files/nba_player_data_light_extra_column.csv'
        elsif table == 'students.csv' or table == './csv_files/students.csv'
            !@table_name and @table_name = './csv_files/students.csv'
            !@second_table_name and @table_name != './csv_files/students.csv' and @second_table_name = './csv_files/students.csv'
        elsif table == 'others.csv' or table == './csv_files/others.csv'
            !@table_name and @table_name = './csv_files/others.csv'
            !@second_table_name and @table_name != './csv_files/others.csv' and @second_table_name = './csv_files/others.csv'
        end
    end

end