%RUN THIS FILE TO START THE GAME

%Developed by Danny, Matt, and Xander. Engineering 1181 SDP.

clear; clc;
fprintf("Engineering 1181 SDP: Tetris V:1.2.0\n");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%The main game board that will hold a gird of pieces.
gameBoard = GameBoard();
gameBoard = gameBoard.generateTitleBoard();

gameBoardPlayer2 = GameBoard();
gameBoardPlayer2.board = uint8(ones(23,10));

%Initializing the game engine and connecting the keyHandler.
keyHandler = KeyHandler();
gameScene = initGameEngine('../res/OldTiles.png', gameBoard, keyHandler);

%The main game framerate target. (If you set the framerate too high the game won't close).
inGameFramerate = 15;
inTitleFramerate = 10;
framerate = 10; 

isAiPlayer = false;

%Variables that will be used to determine if fps should be shown.
showFpsCounter = false;
fpsText = text(20, 30, "FPS: 0", 'Color', [1,1,1]);
delete(fpsText);

%The speed at which the pieces fall. A smaller speed make faster pieces.
pieceSpeed = 5;
pieceSpeedPlayer2 = 5;

pieceFastFallSpeed = 0;

%Used for fastfall.
wasDownJustPressed = false;
wasDownJustPressedPlayer2 = false;

%Used to rotate pieces.
rotateKeyMaxTime = 2;
rotateKeyTimer = 0;
rotateKeyTimerPlayer2 = 0;

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
        gameBoard.board = gameBoard.updateScore(); %updates the score
        gameBoardPlayer2.board = gameBoardPlayer2.updateScore(); %updates the score
        drawScene(gameScene, gameBoard.createTwoPlayerBoard(gameBoardPlayer2))
    elseif (inTitleScreen)
        drawScene(gameScene, gameBoard.getVisibleBackBoard(), gameBoard.getVisibleBoard());
    else
        gameBoard.board = gameBoard.updateScore(); %updates the score
        drawScene(gameScene, gameBoard.getVisibleBoard());
    end

    %Logic for the title screen.
    if (inTitleScreen)
        gameBoard = gameBoard.resetScore();
        gameBoardPlayer2 = gameBoardPlayer2.resetScore();

        framerate = inTitleFramerate;
        [gameBoard, playerCount] = gameBoard.renderTitleScreen(keyHandler);

        if(playerCount ~= 0)
            if(playerCount == 1)
                isMultiplayer = false;
            else
                pieceSpeedPlayer2 = 5;
                isMultiplayer = true;
            end
            
            if playerCount == 3
                pieceSpeedPlayer2 = 0;
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

        %If the escape key is pressed the game exits.
        if(keyHandler.getKeyState(keyHandler.Keys.escape))
            close(gameScene.my_figure);
            playing = false;
        end

        %If the f1 key is pressed change the music.
        if(keyHandler.getKeyState(keyHandler.Keys.f1))
            audioPlayer = startMusicTrack("../res/remix.mp3");
            gameScene = loadNewTileset(gameScene, "../res/NewTiles.png", gameBoard, keyHandler);
        end

   %Game logic.
    else
        %Moving the tetromino down.
        [gameBoard, tetro, player1GameOver, clearedRows] = gameBoard.movePieceDown(tetro, pieceSpeed, 1, keyHandler);

        player2GameOver = false;
        if(isMultiplayer)

            [gameBoardPlayer2, tetroPlayer2, player2GameOver, clearedRowsPlayer2] = gameBoardPlayer2.movePieceDown(tetroPlayer2, pieceSpeedPlayer2, playerCount, keyHandler);

            %If the game is multiplayer then clearingRows gives rows to your oponenet.
            if(clearedRows == 2)
                clearedRows = 0;
                gameBoardPlayer2 = gameBoardPlayer2.queExtraRows(1);
            elseif (clearedRows == 3)
                clearedRows = 0;
                gameBoardPlayer2 = gameBoardPlayer2.queExtraRows(2);
            elseif (clearedRows == 4)
                clearedRows = 0;
                gameBoardPlayer2 = gameBoardPlayer2.queExtraRows(4);
            end

            %If the game is multiplayer then clearingRows gives rows to your oponenet.
            if(clearedRowsPlayer2 == 2)
                clearedRowsPlayer2 = 0;
                gameBoard= gameBoard.queExtraRows(1);
            elseif (clearedRowsPlayer2 == 3)
                clearedRowsPlayer2 = 0;
                gameBoard = gameBoard.queExtraRows(2);
            elseif (clearedRowsPlayer2 == 4)
                clearedRowsPlayer2 = 0;
                gameBoard = gameBoard.queExtraRows(4);
            end
        end
        
        %Handle Key Input for Single Player
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
                if(rotateKeyTimer == 0)
                    rotateKeyTimer = rotateKeyMaxTime;
                    gameBoard = tetro.rotate(gameBoard);
                else
                    rotateKeyTimer = rotateKeyTimer - 1;
                end
            else
                rotateKeyTimer = 0;
            end

        %Handle key input for Multiplayer
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
                if(rotateKeyTimer == 0)
                    rotateKeyTimer = rotateKeyMaxTime;
                    gameBoard = tetro.rotate(gameBoard);
                else
                    rotateKeyTimer = rotateKeyTimer - 1;
                end
            else
                rotateKeyTimer = 0;
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

            %If the down key is released for player 1.
            if (wasDownJustPressedPlayer2 && ~keyHandler.getKeyState(keyHandler.Keys.downArrow))
                wasDownJustPressedPlayer2 = false;
                tetroPlayer2.maxTicsUntilFall = pieceSpeedPlayer2;
                tetroPlayer2.ticsUntilFall = pieceSpeedPlayer2;
            end

            %If the rotate key is pressed for player 2.
            if(keyHandler.getKeyState(keyHandler.Keys.upArrow))
                if(rotateKeyTimerPlayer2 == 0)
                    rotateKeyTimerPlayer2 = rotateKeyMaxTime;
                    gameBoardPlayer2 = tetroPlayer2.rotate(gameBoardPlayer2);
                else
                    rotateKeyTimerPlayer2 = rotateKeyTimerPlayer2 - 1;
                end
            else
                rotateKeyTimerPlayer2 = 0;
            end
        end

        %If the escape key is pressed the game returns to the title screen 
        if(keyHandler.getKeyState(keyHandler.Keys.escape))
            inTitleScreen = true;
            gameBoard = gameBoard.generateTitleBoard();
        end

        %Checking for a game over.
        if(player1GameOver || player2GameOver)
            inTitleScreen = true;
            gameBoard = gameBoard.generateTitleBoard();
        end

    end

    %If the f2 key is pressed the game toggles the fps counter. 
    if(keyHandler.getKeyState(keyHandler.Keys.f2))
        showFpsCounter = ~showFpsCounter;
    end

    %This pause limits the fps based on the framerate variable.
    pause(1/framerate-toc);
    
    %Drawing the current fps.
    delete(fpsText);
    if(showFpsCounter)
        fpsText = text(20, 30, "FPS: " + string(1/toc), 'Color', [1,1,1]);
    end
end

%Stops the audio from playing after the program finishes.
stop(audioPlayer);
delete(audioPlayer);

%Clears the workspace and command window after the program finishes.
clear; clc;

%Used to load an image to a simpleGameENgine file.
function gameScene = loadNewTileset(gameScene, filePath, gameBoard, keyHandler)
    close(gameScene.my_figure);
    pause(0.1);

    assignin('base', 'playing', true);
    gameScene = initGameEngine(filePath, gameBoard, keyHandler);
    figure(gameScene.my_figure);
end

%This method sets up callback methods and initializes a simpleGameEngine.
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
    assignin('base', "showFpsCounter", false);
    delete(src);
end