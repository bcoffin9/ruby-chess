module BoardNav

    def self.address_to_coord(address)
        arr = []
        parsed_address = address.split("")
        file = parsed_address[0]
        rank = parsed_address[1].to_i

        case file
        when "a"
            arr.push(0)
        when "b"
            arr.push(1)
        when "c"
            arr.push(2)
        when "d"
            arr.push(3)
        when "e"
            arr.push(4)
        when "f"
            arr.push(5)
        when "g"
            arr.push(6)
        when "h"
            arr.push(7)
        else
            return []
        end

        if (1..8).include?(rank)
            arr.push(rank-1)
        else
            return []
        end

        return arr
    end

    def self.on_board?(x, y)
        ((0..7).include?(x) && (0..7).include?(y))
    end
    
end