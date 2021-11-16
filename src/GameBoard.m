classdef GameBoard
    
    properties
        board
    end
    
    methods
        function obj = GameBoard()
            obj.board = uint8(ones(23,10));
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

        function [visibileBoard] = getVisibleBoard(obj)
            visibileBoard = obj.board(4:23, :);
        end
        
        function [gameOver] = isGameOver(obj)
            gameOver = false;

            for x = 1:10
                if obj.board(1,x) ~= 1 || obj.board(2,x) ~= 1
                    gameOver = true;
                end
            end
        end

    end
end