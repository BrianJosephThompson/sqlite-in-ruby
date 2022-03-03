module Insert_CLI

    def run_insert_cli
        validate_insert
        if @run_signal == true
            @request.insert(@csv)
            @request.values(@insert_hash)
            @request.run_without_print
        end
        reset
    end


    def validate_insert
        if @input[1].upcase != 'INTO'
            puts "INSERT must be followed by INTO"
            return 0
        end
        validate_csv(@input[2])
        if @input[3].upcase != 'VALUES'
            puts "Table name must be followed by VALUES"
            return 0
        end
        if !@input[4]
            puts "Values must be followed by insert criteria"
            return 0
        else
            create_hash(@input[4])
            @run_signal = true
        end
    end

    def create_hash(input)
        input = input.gsub("(", "").gsub(")", "")
        @insert_vals = input.split(',')
        @valid_student_columns.each do |column|
            @insert_hash[column] = @insert_vals[@insert_index]
            @insert_index += 1
        end
    end

end