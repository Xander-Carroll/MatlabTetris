%RUN THIS FILE TO START THE GAME

%Developed by Danny, Matt, Xander, and Blake. Engineering 1181 SDP.

clear; clc;
fprintf("Engineering 1181 SDP: Tetris V:1.1.0\n");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%The main game framerate target. (If you set the framerate too high the game won't close).
inGameFramerate = 15;
inTitleFramerate = 10;
framerate = 10; 

%The main game board that will hold a gird of pieces.
gameBoard = GameBoard();
gameBoard = gameBoard.generateTitleBoard();

gameBoardPlayer2 = GameBoard();
gameBoardPlayer2.board = uint8(ones(25,10));

keyHandler = KeyHandler();
gameScene = initGameEngine('../res/OldTiles.png', gameBoard, keyHandler);

%The speed at which the pieces fall. A smaller speed make faster pieces.
pieceSpeed = 5;
pieceSpeedPlayer2 = 5;

pieceFastFallSpeed = 0;

%Used for fastfall.
wasDownJustPressed = false;
wasDownJustPressedPlayer2 = false;

%Starts music
audioPlayer = startMusicTrack("../res/original.mp3");

%Creating the first piece. Once this piece lands a new piece is made.
tetro = Tetromino();
tetroPlayer2 = Tetromino();

%This is set to true when the multiplayer option is selected.
isMultiplayer = false;

%Causes the game to start in the title menu.
inTitleScreen = true;

%Starting the main game loop. 
%playing will become false when the game window is closed (Or escape is pressed).
playing = true;
while playing
    tic;

    %Rendering the game scene.
    if(isMultiplayer && ~inTitleScreen)
        drawScene(gameScene, gameBoard.createTwoPlayerBoard(gameBoardPlayer2))
    elseif (inTitleScreen)
        drawScene(gameScene, gameBoard.getVisibleBackBoard(), gameBoard.getVisibleBoard());
    else
        drawScene(gameScene, gameBoard.getVisibleBoard());
    end

    %Logic for the title screen.
    if (inTitleScreen)
        framerate = inTitleFramerate;
        [gameBoard, playerCount] = gameBoard.renderTitleScreen(keyHandler);

        if(playerCount ~= 0)
            if(playerCount == 1)
                isMultiplayer = false;
            else
                isMultiplayer = true;
            end

            gameBoard.board = uint8(ones(25,10));
            gameBoardPlayer2.board = uint8(ones(25,10));
            inTitleScreen = false;
    
            tetro = Tetromino();
            tetro.maxTicsUntilFall = pieceSpeed;
    
            tetroPlayer2 = Tetromino();
            tetroPlayer2.maxTicsUntilFall = pieceSpeedPlayer2;

            framerate = inGameFramerate;
        end

        %If the f1 key is pressed change the music.
        if(keyHandler.getKeyState(keyHandler.Keys.f1))
            audioPlayer = startMusicTrack("../res/remix.mp3");
            gameScene = loadNewTileset(gameScene, "../res/NewTiles.png", gameBoard, keyHandler);
        end

    else
    
        %Moving the tetromino down.
        [gameBoard, tetro, player1GameOver] = gameBoard.movePieceDown(tetro, pieceSpeed);
    
        player2GameOver = false;
        if(isMultiplayer)
            [gameBoardPlayer2, tetroPlayer2, player2GameOver] = gameBoardPlayer2.movePieceDown(tetroPlayer2, pieceSpeedPlayer2);
        end
        
        %Handle Key Input
        if(~isMultiplayer)
            %If the left key is pressed.
            if(keyHandler.getKeyState(keyHandler.Keys.a) || keyHandler.getKeyState(keyHandler.Keys.leftArrow))
                gameBoard = tetro.move('l', gameBoard);
            end

            %If the right key is pressed.
            if(keyHandler.getKeyState(keyHandler.Keys.d) || keyHandler.getKeyState(keyHandler.Keys.rightArrow))
                gameBoard = tetro.move('r', gameBoard);
            end

            %If the down key is pressed.
            if(keyHandler.getKeyState(keyHandler.Keys.s) || keyHandler.getKeyState(keyHandler.Keys.downArrow))
                wasDownJustPressed = true;
                if(tetro.maxTicsUntilFall ~= pieceFastFallSpeed)
                    tetro.maxTicsUntilFall = pieceFastFallSpeed;
                    tetro.ticsUntilFall = 0;
                end
            end

            %If the down key is released.
            if (wasDownJustPressed && ~keyHandler.getKeyState(keyHandler.Keys.s) && ~keyHandler.getKeyState(keyHandler.Keys.downArrow))
                wasDownJustPressed = false;
                tetro.maxTicsUntilFall = pieceSpeed;
                tetro.ticsUntilFall = pieceSpeed;
            end

            %If the rotate key is pressed.
            if(keyHandler.getKeyState(keyHandler.Keys.w) || keyHandler.getKeyState(keyHandler.Keys.upArrow))
                gameBoard = tetro.rotate(gameBoard);
            end
        else
            %If the left key is pressed for player 1.
            if(keyHandler.getKeyState(keyHandler.Keys.a))
                gameBoard = tetro.move('l', gameBoard);
            end

            %If the right key is pressed for player 1.
            if(keyHandler.getKeyState(keyHandler.Keys.d))
                gameBoard = tetro.move('r', gameBoard);
            end

            %If the down key is pressed for player 1.
            if(keyHandler.getKeyState(keyHandler.Keys.s))
                wasDownJustPressed = true;
                if(tetro.maxTicsUntilFall ~= pieceFastFallSpeed)
                    tetro.maxTicsUntilFall = pieceFastFallSpeed;
                    tetro.ticsUntilFall = 0;
                end
            end

            %If the down key is released for player 1.
            if (wasDownJustPressed && ~keyHandler.getKeyState(keyHandler.Keys.s))
                wasDownJustPressed = false;
                tetro.maxTicsUntilFall = pieceSpeed;
                tetro.ticsUntilFall = pieceSpeed;
            end

            %If the rotate key is pressed for player 1.
            if(keyHandler.getKeyState(keyHandler.Keys.w))
                gameBoard = tetro.rotate(gameBoard);
            end

            %If the left key is pressed for player 2.
            if(keyHandler.getKeyState(keyHandler.Keys.leftArrow))
                gameBoardPlayer2 = tetroPlayer2.move('l', gameBoardPlayer2);
            end

            %If the right key is pressed for player 2.
            if(keyHandler.getKeyState(keyHandler.Keys.rightArrow))
                gameBoardPlayer2 = tetroPlayer2.move('r', gameBoardPlayer2);
            end

            %If the down key is pressed for player 2.
            if(keyHandler.getKeyState(keyHandler.Keys.downArrow))
                wasDownJustPressedPlayer2 = true;
                if(tetroPlayer2.maxTicsUntilFall ~= pieceFastFallSpeed)
                    tetroPlayer2.maxTicsUntilFall = pieceFastFallSpeed;
                    tetroPlayer2.ticsUntilFall = 0;
                end
            end

            %If the down key is released for player 2.
            if (wasDownJustPressedPlayer2 && ~keyHandler.getKeyState(keyHandler.Keys.downArrow))
                wasDownJustPressedPlayer2 = false;
                tetroPlayer2.maxTicsUntilFall = pieceSpeedPlayer2;
                tetroPlayer2.ticsUntilFall = pieceSpeedPlayer2;
            end

            %If the rotate key is pressed for player 2.
            if (keyHandler.getKeyState(keyHandler.Keys.upArrow))
                gameBoardPlayer2 = tetroPlayer2.rotate(gameBoardPlayer2);
            end
        end

        %Checking for a game over.
        if(player1GameOver || player2GameOver)
            inTitleScreen = true;
            gameBoard = gameBoard.generateTitleBoard();
        end

    end

    %If the escape key is pressed the game closes.
    if(keyHandler.getKeyState(keyHandler.Keys.escape))
        inTitleScreen = true;
        gameBoard = gameBoard.generateTitleBoard();
    end

    %This pause limits the fps based on the framerate variable.
    pause(1/framerate-toc);
    %fprintf("Framerate: %f\n", 1/toc); %TODO REMOVE: Unccoment this line to see framerate.
end

%Stops the audio from playing after the program finishes.
stop(audioPlayer);
delete(audioPlayer);

%TODO UNCOMMENT: clear; clc;

%This function starts the easter egg version of the game
function gameScene = loadNewTileset(gameScene, filePath, gameBoard, keyHandler)
    close(gameScene.my_figure);
    pause(0.1);

    assignin('base', 'playing', true);
    gameScene = initGameEngine(filePath, gameBoard, keyHandler);
    figure(gameScene.my_figure);
end

%This function initializes the game engine and scene
function gameScene = initGameEngine(filePath, gameBoard, keyHandler)
    %The main game scene. This will need to be drawn to every frame.
    gameScene = SimpleGameEngine(filePath,32,32,1,[0,0,0]);

    %Initializing the game scene. The scene must be drawn once before the game loop and before callback methods can be set.
    drawScene(gameScene, gameBoard.getVisibleBackBoard(), gameBoard.getVisibleBoard());

    %Setting a callback method for the window close event. (Handeled with function at the bottom of the script).
    set(gameScene.my_figure, 'CloseRequestFcn', @closeCallback);

    %Setting a callback method for key press/release events. These are given to the keyHandler object that will be used to get key input.
    set(gameScene.my_figure, 'KeyPressFcn', @keyHandler.onKeyPress);
    set(gameScene.my_figure, 'KeyReleaseFcn', @keyHandler.onKeyRelease);
end

%Takes a filePath to the track to start and plays the file.
function outAudioPlayer = startMusicTrack(filePath)
    [audioFile, fs] = audioread(filePath);
    outAudioPlayer = audioplayer(audioFile, fs);
    set(outAudioPlayer, 'StopFcn', @musicStopped);
    play(outAudioPlayer);
end

%Starts the music again once it stopped.
function musicStopped(src, ~)
    play(src);
end

%Handels window close events. (When the window close button is pressed this function is called).
function closeCallback(src, ~)
    assignin('base', 'playing', false);
    delete(src);
end
