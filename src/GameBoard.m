classdef GameBoard
    
    properties
        board
    end
    
    methods
        function obj = GameBoard()
            obj.board = uint8(ones(20,10));
        end
        
        
        
        function obj = update(obj, pre, post)
            loc = pre.locations;
            
            for i = 1:2:8
                obj.board(loc(i),loc(i+1)) = 1;
            end
            
            loc = post.locations;
            
            for i = 1:2:8
                obj.board(loc(i),loc(i+1)) = post.color;
            end

        end
        
    end
end