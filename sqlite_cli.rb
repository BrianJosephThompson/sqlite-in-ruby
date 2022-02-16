require "readline"

class MySqliteCli
    def parse(buf)
        p buf
    end

    def run!
        while buf = Readline.readline("> ", true)
            instance_of_request = parse(buf)
        end
    end
end

cli = MySqliteCli.new
cli.run!