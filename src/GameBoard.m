classdef GameBoard
    %GAMEBOARD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        board
    end
    
    methods
        function obj = GameBoard()
            %GAMEBOARD Construct an instance of this class
            %   Detailed explanation goes here
            obj.board = uint8(ones(20,10));
        end
        
        
        
        function obj = update(obj, pre, post)
            loc = pre.locations;
            
            for i = 1:2:8
                obj.board(loc(i),loc(i+1)) = 1;
            end
            
            loc = post.locations;
            
            for i = 1:2:8
                obj.board(loc(i),loc(i+1)) = tetro.color;
            end
        end
        
    end
end

