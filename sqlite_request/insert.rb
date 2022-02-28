module Insert

    def insert(table_name)
        set_table_name(table_name)
        @type_of_request = :insert
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
    
    def print_insert
        puts "INSERT INTO #{@table_name}"
        puts "INSERT #{@insert_values}"
    end
    
    def run_insert
        File.open(@table_name, 'a') do |f|
            f.puts @insert_values.values.join(',')
        end
    end
end