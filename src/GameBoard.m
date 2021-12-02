%This class controls what is displayed and contains a grid that keeps track of sprites on the screen
classdef GameBoard
    
    properties
        %The main matrix that holds pieces.
        board

        %Used to determine if a piece has landed (and therefore a new piece should be made).
        collided = false;
        collideTimerMax = 5;
        collideTimer = 5;
        backgroundBoard

        %Variables used to display the title screen.
        titleBackgroundColor = 1;
        titleTickCounter = 0;
        tetCounter = 1;
        isSpawning = true;
        titleTetPieces = TitleTet();

        %Variables to keep score
        playerScore = 0;
    end
    
    methods
        %Initalizes the board with 0's
        function obj = GameBoard()
            %By initializing with ints memory is conserved compared to the doubles that would normally be used.
            obj.board = uint8(ones(25,18));
            obj.backgroundBoard = uint8(ones(25,18));
            obj.backgroundBoard(:) = obj.titleBackgroundColor;
            

            %This loop is used to create the titleTet pieces used to animate the title screen.
            for i = 1:16
                obj.titleTetPieces(i) = TitleTet(mod(i, 2));
            end
        end
        
        %Edits the supplied gameBoard object to make it show a title screen.
        function obj = generateTitleBoard(obj)
            
            obj.board = uint8(ones(25,18));
 
            %MATLAB and TETRIS words
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

            %matlab logo
            for x = 7: 12
                obj.board(7,x) = 48;
            end
 
            %tetris logo
            for x = 7: 12
                obj.board(10,x) = 47;
            end

            
            %SINGLE--PLAYER and MULTI-PLAYER words
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

            obj.board(23,9) = 11;%A
            obj.board(23,10) = 19;%I

            obj.board(24,7) = 26;%P
            obj.board(24,8) = 28;%R
            obj.board(24,9) = 15;%E
            obj.board(24,10) = 29;%S
            obj.board(24,11) = 29;%S
            obj.board(24,12) = 38;%2
            
                
            %Iron Bars

            %Iron bars around single and multi player
            obj.board(15,2) = 56;%left T
            obj.board(19,3) = 56;%left T

            obj.board(15,17) = 50;%right T
            obj.board(19,16) = 50;%right T
            
            obj.board(16,6) = 53;%top right corner
            obj.board(20,6) = 53;%top right corner

            obj.board(16,13) = 52;%top left corner
            obj.board(20,13) = 52;%top left corner
            
            for z = 3:6 %upside down T
                 obj.board(14,z) = 51;
            end
            for z = 14:16 %upside down T
                 obj.board(14,z) = 51;
            end
            
            for z = 1:3 %regualr T
                obj.board(16,z+2) = 57;
                obj.board(16,z+13) = 57;
            end

            obj.board(20,z+3) = 57;

            for x = 4:5
                obj.board(20,x) = 57;
                obj.board(18,x) = 51;
            end
            for x = 14:15
                obj.board(20,x) = 57;
                obj.board(18,x) = 51;
            end
            obj.board(20,6) = 53;

            obj.board(23,6) = 56;
            obj.board(24,6) = 56;

            obj.board(23,13) = 50;
            obj.board(24,13) = 50;

            obj.board(18,6) = 55;
            obj.board(14,6) = 55;
            obj.board(20,13) = 52;
            obj.board(18,13) = 54;
            obj.board(14,13) = 54;

            obj.board(17,6) = 56;
            obj.board(17,13) = 50;

            obj.board(4, 1) = 52;
            obj.board(25, 1) = 54;

            obj.board(4, 18) = 53;
            obj.board(25, 18) = 55;

            %Border/edge
            for x = 2:6
                obj.board(4, x) = 57;
                obj.board(25, x) = 51;
            end
            for x = 13:17
                obj.board(4, x) = 57;
                obj.board(25, x) = 51;
            end

            for x = 7:12
                obj.board(4, x) = 58;
                obj.board(25, x) = 58;
            end

            for y = 5:24
                obj.board(y, 1) = 50;
                obj.board(y, 18) = 56;
            end

            %Sideways T pieces by the MATLAB and TETRIS
            for y = 5:13
                obj.board(y,6) = 56;
                obj.board(y,13) = 50;
            end
            for y = 21:22
                obj.board(y,6) = 56;
                obj.board(y,13) = 50;
            end

            %fill the rest with crosses
            for y = 1:25
                for x = 1:6
                    if obj.board(y,x) == 1
                        obj.board(y,x) = 49;
                    end
                end
                for x = 13:18
                    if obj.board(y,x) == 1
                        obj.board(y,x) = 49;
                    end
                end
            end
            
        end
        
        %This function displays the score
        function returnBoard = updateScore(obj) 
            obj.board(24,:) = 9;
            obj.board(25,5:6) = 46;

            if obj.playerScore < 10 && obj.playerScore > 0
                obj.board(25,6) = obj.playerScore + 36;
            elseif obj.playerScore < 100 && obj.playerScore >= 10
                if ~mod(obj.playerScore, 10) == 0
                    obj.board(25,6) = mod(obj.playerScore, 10) + 36;
                end
                obj.board(25,5) = floor(obj.playerScore / 10) + 36;
            end
            returnBoard = obj.board;
        end
            
        %This function resets the score when the game is over
        function obj = resetScore(obj)
            obj.playerScore = 0;
        end
        
        %Called on each tetro piece every frame to move it down the screen.
        function [obj, tetro, gameOver] = movePieceDown(obj, tetro, speed)
            [obj, obj.collided] = tetro.move('d', obj);

            gameOver = false;

            %Once a piece has landed it is determined if the player has lost, if any lines have been cleared, and creates a new tetro.
            if (obj.collided)
                if(obj.collideTimer > 0)
                    obj.collideTimer = obj.collideTimer - 1;
                else
                    obj.collideTimer = obj.collideTimerMax;

                    if (obj.isGameOver())
                        gameOver = true;
                        obj = obj.generateTitleBoard();
                    else
                        tetro = Tetromino();
                        tetro.maxTicsUntilFall = speed;
                        obj.collided = false;
    
                        obj = obj.clearCompleteRows();
                    end

                end
    
            else
                obj.collideTimer = obj.collideTimerMax;
            end
    
        end

        %This method takes the position of a current piece before and after moving and updates the board matrix appropriatley.
        function obj = updateTetrisPiece(obj, pre, post)            
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
            visibileBoard = obj.board(4:25, :);
            
        end
        
        function visibleBackBoard = getVisibleBackBoard(obj)
            visibleBackBoard = obj.backgroundBoard(4:25, :);
        end

        %This function should be called when a piece lands to determine if any lines need to be cleared.
        function obj = clearCompleteRows(obj)
            linesClearedCount = 0;

            for y = 1:23
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
                    linesClearedCount = linesClearedCount + 1;
                end
            end

            if (linesClearedCount == 1) 
                obj.playerScore = obj.playerScore + 1;
            elseif (linesClearedCount == 2)
                obj.playerScore = obj.playerScore + 3;
            elseif (linesClearedCount == 3)
                obj.playerScore = obj.playerScore + 5;
            elseif (linesClearedCount == 4)
                obj.playerScore = obj.playerScore + 8;
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
            returnBoard = uint8(ones(20,25));

            board1 = obj.getVisibleBoard();
            board2 = gameBoard2.getVisibleBoard();
            
            for y = 1:length(board1(:, 1))
                returnBoard(y,1:10) = board1(y,:);
                returnBoard(y,11:15) = 9;
                returnBoard(y,16:25) = board2(y,:);
            end
        end

        %Updates TitleTet Pieces when the gameBoard is displaying a title screen.
        function [obj, playerCount] = renderTitleScreen(obj, keyHandler)
            playerCount = 0;

            %Spawning titleTet pieces
            if mod(obj.titleTickCounter, 4) == 0 && obj.isSpawning
                obj.backgroundBoard(obj.titleTetPieces(obj.tetCounter).getY(), obj.titleTetPieces(obj.tetCounter).getX()) = obj.titleTetPieces(obj.tetCounter).getColor();
                obj.titleTetPieces(obj.tetCounter).isOnBoard = true;
                obj.tetCounter = obj.tetCounter + 1;
            
                if obj.tetCounter == 17
                    obj.isSpawning = false;
                end

            end

            if(keyHandler.getKeyState(keyHandler.Keys.key1))
                playerCount = 1;
            elseif(keyHandler.getKeyState(keyHandler.Keys.key0))
                playerCount = 2;
            else
                for i = 1:16 %update titletet locations
                    if obj.titleTetPieces(i).isOnBoard == true
                        obj.backgroundBoard(obj.titleTetPieces(i).getY(), obj.titleTetPieces(i).getX()) =  obj.titleBackgroundColor;
                        obj.titleTetPieces(i).moveDown();
                    end
                end
       
                for i = 1:16 %update gameboard with new titleTet locations
                    if obj.titleTetPieces(i).isOnBoard == true
                        obj.backgroundBoard(obj.titleTetPieces(i).getY(), obj.titleTetPieces(i).getX()) =  obj.titleTetPieces(i).getColor();
                    end
                end    
                        
                if obj.titleTickCounter < 200
                    obj.titleTickCounter = obj.titleTickCounter + 1;
                end
            end
        end
    end
end