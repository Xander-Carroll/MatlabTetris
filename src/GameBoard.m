classdef GameBoard
    
    properties
        %The main matrix that holds pieces.
        board
        backgroundBoard
    end
    
    methods
        %Initalizes the board with 0's
        function obj = GameBoard()
            %By initializing with ints memory is conserved compared to the doubles that would normally be used.
            obj.board = uint8(ones(23,18));
            obj.backgroundBoard = uint8(ones(23,18));
            
        end
        
        function obj = generateTitleBoard(obj)


            for x = 2:17
                obj.board(4, x) = 57;
                obj.board(23, x) = 51;
            end
            for y = 5:22
                obj.board(y, 1) = 50;
                obj.board(y, 18) = 56;
            end

            obj.board(4, 1) = 52;
            obj.board(23, 1) = 54;

            obj.board(4, 18) = 53;
            obj.board(23, 18) = 55;

            
            obj.board(8,7) = 23;%M
            obj.board(8,8) = 11;%A
            obj.board(8,9) = 30;%T
            obj.board(8,10) = 22;%L
            obj.board(8,11) = 11;%A
            obj.board(8,12) = 12;%B
  
            obj.board(9,7) = 30;%T
            obj.board(9,8) = 15;%E
            obj.board(9,9) = 30;%T
            obj.board(9,10) = 28;%R
            obj.board(9,11) = 19;%I
            obj.board(9,12) = 29;%S

            %Sideways T pieces by the MATLAB and TETRIS
            obj.board(8,6) = 56;
            obj.board(8,13) = 50;
            obj.board(9,6) = 56;
            obj.board(9,13) = 50;
            
            
            %for x = 2:17
            %    obj.board(11, x) = 48;
            %    obj.board(12, x) = 47;
            %end
        
            %matlab logo
            for x = 7: 12
            obj.board(7,x) = 48;
            end
            %obj.board(7,6) = 48;
            %obj.board(8,6) = 48;
            %obj.board(7,13) = 48;
            %obj.board(8,13) = 48;
            
            %tetris logo
            for x = 7: 12
            obj.board(10,x) = 47;
            end
            %obj.board(10,6) = 47;
            %obj.board(10,13) = 47;
            %obj.board(9,6) = 47;
            %obj.board(9,13) = 47;
            




         
            

            obj.board(15,3) = 29;%S
            obj.board(15,4) = 19;%I
            obj.board(15,5) = 24;%N
            obj.board(15,6) = 17;%G
            obj.board(15,7) = 22;%L
            obj.board(15,8) = 15;%E
            obj.board(15,9) = 10;%
            obj.board(15,10) = 10;%
            obj.board(15,11) = 26;%P
            obj.board(15,12) = 22;%L
            obj.board(15,13) = 11;%A
            obj.board(15,14) = 35;%Y
            obj.board(15,15) = 15;%E
            obj.board(15,16) = 28;%R

            obj.board(16,7) = 26;%P
            obj.board(16,8) = 28;%R
            obj.board(16,9) = 15;%E
            obj.board(16,10) = 29;%S
            obj.board(16,11) = 29;%S
            obj.board(16,12) = 37;%1
            


            obj.board(19,4) = 23;%M
            obj.board(19,5) = 31;%U
            obj.board(19,6) = 22;%L
            obj.board(19,7) = 30;%T
            obj.board(19,8) = 19;%I
            obj.board(19,9) = 10;%
            obj.board(19,10) = 26;%P
            obj.board(19,11) = 22;%L
            obj.board(19,12) = 11;%A
            obj.board(19,13) = 35;%Y
            obj.board(19,14) = 15;%E
            obj.board(19,15) = 28;%R
            
            obj.board(20,7) = 26;%P
            obj.board(20,8) = 28;%R
            obj.board(20,9) = 15;%E
            obj.board(20,10) = 29;%S
            obj.board(20,11) = 29;%S
            obj.board(20,12) = 46;%0




            %pieces around single and multi player
            obj.board(15,2) = 56;%left T
            obj.board(19,3) = 56;%left T

            obj.board(15,17) = 50;%right T
            obj.board(19,16) = 50;%right T
            
            obj.board(16,6) = 53;%top right corner
            obj.board(20,6) = 53;%top right corner

            obj.board(16,13) = 52;%top left corner
            obj.board(20,13) = 52;%top left corner

            
            %%single
            
            for z = 3:16 %upside down T
                 obj.board(14,z) = 51;
            end
            
            
            for z = 7:12 %regualr T
                obj.board(17,z) = 57;
            end

            for z = 1:3 %regualr T
                obj.board(16,z+2) = 57;
                obj.board(16,z+13) = 57;
            end

            %%multi
            for z = 1:2 %regualr T
                obj.board(20,z+3) = 57;
                obj.board(20,z+13) = 57;
            end
      

            for z = 4:15 %upside down T
                obj.board(18,z) = 51;
            end
            for z = 7:12 %regualr T
                obj.board(21,z) = 57;
            end
            



            
            for y = 1:23
                for x = 1:18
                    if obj.board(y,x) == 1
                        obj.board(y,x) = 49;
                    end
                end
            end
            
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
        
        function visibleBackBoard = getVisibleBackBoard(obj)
            visibleBackBoard = obj.backgroundBoard(4:23, :);
        end

        function setBackBoard(obj, y, x, color)
            obj.backgroundBoard(y,x) = color;
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
