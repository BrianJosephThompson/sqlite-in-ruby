module Delete_CLI

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
            return 0
        end
        validate_csv(@input[2])
        if (@input[3].upcase != 'WHERE')
            puts "Table Name must be followed by WHERE"
            return 0
        end
        validate_where(@input[2], @input[4])
        if (@input[5] != '=')
            puts "WHERE reference must be followed by ="
            return 0
        end
        if !@input[6]
            puts "WHERE = must be followed by criteria"
            return 0
        else
            @where_criteria = @input[6]
            @run_signal = true
        end
    end

end