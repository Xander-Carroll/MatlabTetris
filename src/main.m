%RUN THIS FILE TO START THE GAME

%Developed by Danny, Matt, and Xander. Engineering 1181 SDP.

clear; clc;
fprintf("Engineering 1181 SDP: Tetris V:0.0.1\n");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%The main game framerate target. (If you set the framerate too high the game won't close).
framerate = 15; 

%The main game scene. This will need to be drawn to every frame.
gameScene = simpleGameEngine('../res/Tiles.png',32,32,1,[255,255,255]);

%The main game board that will hold a gird of pieces.
gameBoard = GameBoard();
gameBoard = gameBoard.generateTitleBoard();

gameBoardPlayer2 = GameBoard();
gameBoardPlayer2.board = uint8(ones(23,10));

%Initializing the game scene. The scene must be drawn once before the game loop and before callback methods can be set.
drawScene(gameScene, gameBoard.getVisibleBoard());

%Setting a callback method for the window close event. (Handeled with function at the bottom of the script).
set(gameScene.my_figure, 'CloseRequestFcn', @closeCallback);

%Setting a callback method for key press/release events. These are given to the keyHandeler object that will be used to get key input.
keyHandeler = KeyHandeler();
set(gameScene.my_figure, 'KeyPressFcn', @keyHandeler.onKeyPress);
set(gameScene.my_figure, 'KeyReleaseFcn', @keyHandeler.onKeyRelease);

%The speed at which the pieces fall. A smaller speed make faster pieces.
pieceSpeed = 1;
pieceSpeedPlayer2 = 5;

%Creating the first piece. Once this piece lands a new piece is made.
tetro = Tetromino();
tetroPlayer2 = Tetromino();

isMultiplayer = false;

%Starting the main game loop. 
%playing will become false when the game window is closed (Or escape is pressed).
playing = true;
inTitleScreen = true;
while playing
    tic;

    %Rendering the game scene.
    if(isMultiplayer && ~inTitleScreen)
        drawScene(gameScene, gameBoard.createTwoPlayerBoard(gameBoardPlayer2))
    else
        drawScene(gameScene, gameBoard.getVisibleBoard());
    end

    %Logic for the title screen.
    if (inTitleScreen) 
        [y,x] = getMouseInput(gameScene);
        if (y <= 10) %singleplayer
            isMultiplayer = false;
        else %multiplayer
            isMultiplayer = true;
        end

        gameBoard.board = uint8(ones(23,10));
        gameBoardPlayer2.board = uint8(ones(23,10));
        inTitleScreen = false;

        tetro = Tetromino();
        tetro.maxTicsUntilFall = pieceSpeed;

        tetroPlayer2 = Tetromino();
        tetroPlayer2.maxTicsUntilFall = pieceSpeedPlayer2;
    else
    
        %Moving the tetromino down.
        [gameBoard, tetro, player1GameOver] = gameBoard.movePieceDown(tetro, pieceSpeed);
    
        player2GameOver = false;
        if(isMultiplayer)
            [gameBoardPlayer2, tetroPlayer2, player2GameOver] = gameBoardPlayer2.movePieceDown(tetroPlayer2, pieceSpeedPlayer2);
        end

        fprintf('DOWN: %i\n', keyHandeler.getKeyState(keyHandeler.Keys.downArrow));
        fprintf('UP: %i\n', keyHandeler.getKeyState(keyHandeler.Keys.upArrow));

        %Checking for a game over.
        if(player1GameOver || player2GameOver)
            inTitleScreen = true;
        end

    end

    %This pause limits the fps based on the framerate variable.
    pause(1/framerate-toc);
    %fprintf("Framerate: %f\n", 1/toc); %TODO REMOVE: Unccoment this line to see framerate.
end

%TODO UNCOMMENT: clear; clc;

%Handels window close events. (When the window close button is pressed this function is called).
function closeCallback(src, ~)
    assignin('base', 'playing', false);
    delete(src);
end