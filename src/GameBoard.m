classdef GameBoard
    
    properties
        %The main matrix that holds pieces.
        board
    end
    
    methods
        %Initalizes the board with 0's
        function obj = GameBoard()
            %By initializing with ints memory is conserved compared to the doubles that would normally be used.
            obj.board = uint8(ones(23,10));
            
        end
        
        function obj = generateTitleBoard(obj)
            obj.board(4,:) = 9;
            obj.board(23,:) = 9;
            obj.board(:,1) = 9;
            obj.board(:,10) = 9; 
            obj.board(13,:) = 9;
            obj.board(14,:) = 9;
            
            obj.board(8,3) = 11;
            obj.board(8,4) = 12;
            obj.board(8,5) = 13;
            obj.board(8,6) = 14;
            obj.board(8,7) = 15;
            obj.board(8,8) = 16;
  
            obj.board(9,3) = 17;
            obj.board(9,4) = 15;
            obj.board(9,5) = 18;
            obj.board(9,6) = 19;
            obj.board(9,7) = 16;
            obj.board(9,8) = 20;  
 
            obj.board(18,3) = 21;
            obj.board(18,4) = 22;
            obj.board(18,5) = 15;
            obj.board(18,6) = 23;
            obj.board(18,7) = 12;
            obj.board(18,8) = 24;
  
            obj.board(19,3) = 17;
            obj.board(19,4) = 15;
            obj.board(19,5) = 18;
            obj.board(19,6) = 19;
            obj.board(19,7) = 16;
            obj.board(19,8) = 20;
            
            obj.board = obj.board;
        end

        %This method takes the position of a current piece before and after moving and updates the board matrix appropriatley.
        function obj = update(obj, pre, post)            
            %Removes the piece from its old location.
            for i = 1:2:8
                obj.board(pre.locations(i), pre.locations(i+1)) = 1;
            end
                        
            %Redraws the piece at the new location.
            for i = 1:2:8
                obj.board(post.locations(i), post.locations(i+1)) = post.color;
            end

        end

        %The tetris board contains three rows at the top that the user can't see. 
        %This function returns a board that dosent show those three rows.
        function visibileBoard = getVisibleBoard(obj)
            visibileBoard = obj.board(4:23, :);
        end
        
        %This function should be called when a piece lands to determine if any lines need to be cleared.
        function obj = clearCompleteRows(obj)
            for y = 1:length(obj.board(:,1))
                lineClear = true;

                %Determines if a line needs cleared.
                for x = 1:length(obj.board(1,:))
                    if(obj.board(y,x) == 1)
                        lineClear = false;
                    end
                end

                %If the line does need cleared it is removed and the rows above it are shifted down.
                if lineClear
                    obj.board((2:y),:) = obj.board((1:y-1), :);
                    obj.board(1,:) = uint8(ones(1,10));
                end
            end
        end

        %This function should be called when a piece lands to determine if the player has lost.
        function gameOver = isGameOver(obj)
            gameOver = false;

            %Checks to see if any pieces are in the top two rows of the gameboard.
            for x = 1:length(obj.board(1,:))
                if obj.board(1,x) ~= 1 || obj.board(2,x) ~= 1
                    gameOver = true;
                end
            end
        end

        %Takes an additional board as a parameter and creates a matrix that shows both boards at once.
        function returnBoard = createTwoPlayerBoard(obj, gameBoard2)
            returnBoard = uint8(ones(23,25));

            board1 = obj.getVisibleBoard();
            board2 = gameBoard2.getVisibleBoard();
            
            for y = 1:length(board1(:, 1))
                returnBoard(y,1:10) = board1(y,:);
                returnBoard(y,11:15) = 9;
                returnBoard(y,16:25) = board2(y,:);
            end
        end

    end
end
