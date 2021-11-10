%RUN THIS FILE TO START THE GAME

%Developed by Danny, Matt, and Xander. Engineering 1181 SDP.

clear; clc;
fprintf("Engineering 1181 SDP: Tetris V:0.0.1\n");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%The main game scene. This will need to be drawn to every frame.
gameScene = simpleGameEngine('../res/Tiles.png',32,32,5, [255,255,255]);

%The main game board. Initialized to a blank board. (Using ints instead of doubles for better memory management).
global gameBoard
gameBoard = uint8(ones(20,10));

%Creating a test piece.
%gameBoard(3,5) = 3; gameBoard(3,6) = 3; gameBoard(3,7) = 3; gameBoard(4,6) = 3;
tit = Tetromino(); titLoc = tit.locations;
gameBoard = drawTetro(tit, gameBoard);

%Initializing the game scene. The scene must be drawn once before the game loop and before callback methods can be set.
drawScene(gameScene, gameBoard);

%Setting callback methods for keypress and window close events. (Handeled with functions at the bottom of the script).
set(gameScene.my_figure, 'KeyPressFcn', {@keyPressEvent, tit});
set(gameScene.my_figure, 'CloseRequestFcn', @closeCallback);

%Starting the main game loop. 
%playing will become true when the game window is closed.
playing = true;
while playing
    tic;

    %Rendering the game scene.
    drawScene(gameScene, gameBoard);

    
    %DO GAME LOGIC HERE.
    gameBoard = eraseTetro(tit, gameBoard);
    tit.move(0);
    gameBoard = drawTetro(tit, gameBoard);

    %This pause creates a consistent 0.1 second game loop.
    pause(0.3-toc);
    
    %fprintf("Time from last render loop: %.4f\n", toc);  %UNCOMMENT THIS LINE TO SEE THAT WE ARE RUNNING AT 1 LOOP EVERY 0.1 SECONDS.
end

%TODO UNCCOMENT: clear; clc;

%Handels key events. (When a key is pressed this function is called).
function keyPressEvent(~, event, tetro)
    global gameBoard
    gameBoard = eraseTetro(tetro, gameBoard);
    if event.Key == 'a'
        tetro.move(-1)
    elseif event.Key == 'd'
        tetro.move(1)
    end
    gameBoard = drawTetro(tetro, gameBoard);
end

%Handels window close events. (When the window is closed this function is called).
function closeCallback(src, ~)
    assignin('base', 'playing', false);
    delete(src);
end

function gameBoard = drawTetro(tetro, gameBoard)
    loc = tetro.locations;
    for i = 1:2:8
        gameBoard(loc(i),loc(i+1)) = tetro.color;
    end
end

function gameBoard = eraseTetro(tetro, gameBoard)   
    loc = tetro.locations;
    for i = 1:2:8
        gameBoard(loc(i),loc(i+1)) = 1;
    end
end
