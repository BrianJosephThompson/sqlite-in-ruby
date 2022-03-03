module Update_CLI

    def run_update_cli
        index = 0
        @input.collect! { |entry| entry = clean(entry) }
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
            return 0
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
            return 0
        end
        if @input[10]
            if (@input[9].upcase == 'WHERE' and @input[11] == '=')
                validate_where(@input[1], @input[10])
                @where_criteria = @input[12]
                @run_signal = true
            elsif (@input[9].upcase == 'WHERE' and @input[11] != '=')
                puts "SET criteria = value must be followed by WHERE criteria = value"
                return 0
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

end