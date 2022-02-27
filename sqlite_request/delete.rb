module Delete

    def delete
        @type_of_request = :delete
        self
    end
    
    def print_delete
        puts "DELETE FROM #{@table_name}"
        if (@where_key)
            puts "WHERE #{@where_key} = #{@where_value}"
        end
    end

    def run_delete
        csv = CSV.read(@table_name, headers: true)
        csv.delete_if do |row|
            row[@where_key] == @where_value
        end
        update_file(csv)
    end
end