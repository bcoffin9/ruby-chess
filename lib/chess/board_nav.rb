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

    def self.coord_to_address(coord)
        file = coord[0]
        rank = coord[1]
        address = ""

        case file
        when 0
            address << "a"
        when 1
            address << "b"
        when 2
            address << "c"
        when 3
            address << "d"
        when 4
            address << "e"
        when 5
            address << "f"
        when 6
            address << "g"
        when 7
            address << "h"
        else
            return ""
        end
        
        if (0..7).include?(rank)
            return address << (rank + 1).to_s
        else
            return ""
        end
    end

    def self.on_board?(x, y)
        ((0..7).include?(x) && (0..7).include?(y))
    end
    
end