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

        function visibileBoard = getVisibleBoard(obj)
            visibileBoard = obj.board(4:23, :);
        end
        
        function obj = clearCompleteRows(obj)
            for y = 1:length(obj.board(:,1))
                lineClear = true;
                for x = 1:length(obj.board(1,:))
                    if(obj.board(y,x) == 1)
                        lineClear = false;
                    end
                end

                if lineClear
                    obj.board((2:y),:) = obj.board((1:y-1), :);
                    obj.board(1,:) = uint8(ones(1,10));
                end
            end
        end

        function gameOver = isGameOver(obj)
            gameOver = false;

            for x = 1:length(obj.board(1,:))
                if obj.board(1,x) ~= 1 || obj.board(2,x) ~= 1
                    gameOver = true;
                end
            end
        end

        function returnBoard = createTwoPlayerBoard(gameBoard1, gameBoard2)
            returnBoard = uint8(ones(23,25));

            board1 = gameBoard1.board;
            board2 = gameBoard2.board;
            
            for y = 1:length(board1(:, 1))
                returnBoard(y,1:10) = board1(y,:);
                returnBoard(y,11:15) = 9;
                returnBoard(y,16:25) = board2(y,:);
            end
        end

    end
end
