module Select

    def select(column_name)
        @type_of_request = :select
        if (column_name.is_a?(Array))
            @select_columns += column_name.collect { |var| var.to_s }
        else
            @select_columns << column_name.to_s
        end
        self
    end

    def order(order, column_name)
        @order_column = column_name
        @order = order
        self
    end

    def join(col_a, file_b, col_b)
        @join_column_db_a   = col_a
        @join_column_db_b   = col_b
        set_table_name(file_b)
        !@second_table_name and raise "Invalid file name for second database. Please confirm the file name is correct and is not the same as the first database name"
        self
    end

    def print_select
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

    def run_select
        csv = CSV.parse(File.read(@table_name), headers: true)
        csv.each do |row|
            if @select_columns[0] == '*'
                @select_result << row.to_hash
            elsif @where_key_2.nil? and @where_key
                if row[@where_key] == @where_value
                    @select_result << row.to_hash.slice(*@select_columns)
                end
            elsif @where_key and @where_key_2 and @where_value and @where_value_2
                if row[@where_key] == @where_value and row[@where_key_2] == @where_value_2
                    @select_result << row.to_hash.slice(*@select_columns)
                end
            elsif !@where_key and !@where_value and !@join_column_db_a
                @select_result << row.to_hash.slice(*@select_columns)
            elsif @join_column_db_a and @join_column_db_b and @second_table_name
                @select_result << row.to_hash.slice(*@select_columns)
            end
        end
        run_join(@select_result)
        order_check(@select_result)
        @select_result
    end

    def run_join(result)
        if @join_column_db_a and @join_column_db_b and @second_table_name
        
            CSV.parse(File.read(@second_table_name), headers: true).collect do |row|
                entry = result.select { |entry| entry[@join_column_db_a] == row[@join_column_db_a] }.first
                entry[@join_column_db_b] = row[@join_column_db_b]
            end
        end
        @select_result = result
    end

    def order_check(result)
        if (@order == :asc and @order_column)
            result.sort_by! { |key| key[@order_column].to_s }
        elsif (@order == :desc and @order_column)
            result.sort_by! { |key| key[@order_column].to_s }.reverse!
        end
        @select_result = result       
    end
    
end