module Update

    def update(table_name)
        @table_name = table_name
        @type_of_request = :update
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
    
    def print_update
        puts "UPDATE #{@table_name}"
        puts "SET #{@update_attributes}"
        if (@where_key)
            puts "WHERE #{@where_key} = #{@where_value}"
        end
    end
    
    def run_update        
        csv = CSV.read(@table_name, headers: true)
        csv.each do |row|
            if row[@where_key] == @where_value
                @update_attributes.each do |key, value|
                row[key] = value
                end
            end
        end
        update_file(csv)
    end

    
    def update_file(csv)
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

end