module Select_CLI

    def run_select_cli
        validate_select
        if @run_signal == true
            if @select_cols == '*'
                select_star             
            elsif @select_cols.each {|x| x != '*'}
                select_reg
            end
        end
        reset
    end

    def validate_select
        parse_select_columns(@input[1])
        if @input[2].upcase != 'FROM'
            puts "Select columns must be followed by FROM"
            return 0
        end
        validate_csv(@input[3])
        if !@input[4]
            @run_signal = true
        end
        if @input[4] and @input[4].upcase == 'WHERE'
            where_present(@input[3], @input[5], @input[6], @input[7], @input[8], @input[9], @input[10])
        end
        if @input[8] and @input[8].upcase == 'ORDER'
            validate_order(@input[8], @input[9], @input[10], @input[11])
        end
        if @input[4] and @input[4].upcase == 'JOIN'
            validate_join(@input[3], @input[5], @input[6], @input[7], @input[8], @input[9])
        end
    end

    def select_reg
        @request.from(@csv)
        @select_cols.each { |value| @request.select(value) }
        @where_col and @request.where(@where_col, @where_criteria)
        @where_col_2 and @request.where(@where_col_2, @where_criteria_2)
        @order_direction and @request.order(@order_direction, @order_criteria)
        @csv_2 and @join_col_db_a and @join_col_db_b and @request.join(@join_col_db_a, @csv_2, @join_col_db_b)
        result = @request.run_without_print
        @index = result.count
        result = result.flat_map(&:values)
        result.each { |entry| @result_array << entry }
        @count = @index * (@select_cols.count + @join_flag)
        print_columns(@count, @select_cols.count + @join_flag, @result_array)
    end 



    def select_star
        result = []
        @request.from(@csv)
        @request.select(@select_cols)
        result = @request.run_without_print
        print_select_star(result)
    end
            
    def print_select_star(result)
        @index = result.count
        result = result.flat_map(&:values)
        result.each { |entry| @result_array << entry }
        if (@csv == './csv_files/students.csv')
            @count = @index * @valid_student_columns.count
            print_columns(@count, @valid_student_columns.count, @result_array)
        elsif (@csv == './csv_files/nba_player_data.csv')
            @count = @index * @valid_nba_columns.count
            print_columns(@count, @valid_nba_columns.count, @result_array)
        end
    end



    def validate_join(database_1, database_2, on, join_col_db_a, equals, join_col_db_b)
        validate_csv(database_2)
        if on.upcase == 'ON' and join_col_db_a and equals == '=' and join_col_db_b
            parse_join(join_col_db_a, join_col_db_b)
        end
    end

    def parse_join(join_col_db_a, join_col_db_b)
        join_col_db_a = join_col_db_a.split(".")
        @join_col_db_a = join_col_db_a[1]
        puts "Join A element but be in the format Table_a.column_reference" if !@join_col_db_a
        join_col_db_b = join_col_db_b.split(".")
        @join_col_db_b = join_col_db_b[1]
        if !@join_col_db_b
            puts "Join B element but be in the format Table_b.column_to_be_joined"
        elsif @join_col_db_b and @join_col_db_a
            @run_signal = true
            @join_flag = 1
        end
    end

    def validate_order(order, by_or_criteria, direction_or_criteria, direction)
        if direction and by_or_criteria == 'BY'
            @order_criteria = direction_or_criteria
            if direction.upcase == 'ASC' or direction.upcase == 'DESC'
                direction.upcase == 'ASC' ? @order_direction = :asc : @order_direction = :desc
                @run_signal = true
            end
        elsif !direction 
            @order_criteria = by_or_criteria
            if direction_or_criteria.upcase == 'ASC' or direction_or_criteria.upcase == 'DESC'
                direction_or_criteria.upcase == 'ASC' ? @order_direction = :asc : @order_direction = :desc
                @run_signal = true
            end
        end
    end

    def where_present(table, key, equal, criteria, next_key, next_equal, next_criteria)
        validate_where_params(table, key, equal, criteria)
        if !next_key
            @run_signal = true
        end
        if (@valid_student_columns.include? next_key) or (@valid_nba_columns.include? next_key)
            validate_where_params(table, next_key, next_equal, next_criteria)
            @run_signal = true
        end
    end

    def parse_select_columns(columns)
        if columns == '*'
            @select_cols = '*'
        else
            @select_cols = columns.split(",")
        end
    end

    def print_columns(count, select_cols, result_array)
        i = 0
        while (i < count)
            if (select_cols == 1)
                puts "#{result_array[i]}"
                i += select_cols
            elsif (select_cols == 2)
                puts "#{result_array[i]}|#{result_array[i+1]}"
                i += select_cols
            elsif (select_cols == 3)
                puts "#{result_array[i]}|#{result_array[i+1]}|#{result_array[i+2]}"
                i += select_cols
            elsif (select_cols == 4)
                puts "#{result_array[i]}|#{result_array[i+1]}|#{result_array[i+2]}|#{result_array[i+3]}"
                i += select_cols
            elsif (select_cols == 5)
                puts "#{result_array[i]}|#{result_array[i+1]}|#{result_array[i+2]}|#{result_array[i+3]}|#{result_array[i+4]}"
                i += select_cols
            elsif (select_cols == 6)
                puts "#{result_array[i]}|#{result_array[i+1]}|#{result_array[i+2]}|#{result_array[i+3]}|#{result_array[i+4]}|#{result_array[i+5]}"
                i += select_cols
            elsif (select_cols == 7)
                puts "#{result_array[i]}|#{result_array[i+1]}|#{result_array[i+2]}|#{result_array[i+3]}|#{result_array[i+4]}|#{result_array[i+5]}|#{result_array[i+6]}"
                i += select_cols
            elsif (select_cols == 8)
                puts "#{result_array[i]}|#{result_array[i+1]}|#{result_array[i+2]}|#{result_array[i+3]}|#{result_array[i+4]}|#{result_array[i+5]}|#{result_array[i+6]}|#{result_array[i+7]}"
                i += select_cols
            end
        end
    end

end