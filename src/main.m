%RUN THIS FILE TO START THE GAME

%Developed by Danny, Matt, and Xander. Engineering 1181 SDP.

clear; clc;
fprintf("Engineering 1181 SDP: Tetris V:0.0.1\n");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%The main game scene. This will need to be drawn to every frame.
gameScene = simpleGameEngine('../res/Tiles.png',32,32,5, [255,255,255]);

%The main game board. Initialized to a blank board. (Using ints instead of doubles for better memory management).
global gameBoard
gameBoard = GameBoard();

%Creating a test piece.
%gameBoard(3,5) = 3; gameBoard(3,6) = 3; gameBoard(3,7) = 3; gameBoard(4,6) = 3;
tetro = Tetromino(); tetroLoc = tetro.locations;

%Initializing the game scene. The scene must be drawn once before the game loop and before callback methods can be set.
drawScene(gameScene, gameBoard.board);

%Setting callback methods for keypress and window close events. (Handeled with functions at the bottom of the script).
set(gameScene.my_figure, 'CloseRequestFcn', @closeCallback);

%Starting the main game loop. 
%playing will become false when the game window is closed.

%The main game framerate target. (If you set the framerate too high the game won't close).
framerate = 10; 

playing = true;
while playing
    tic;

    %Rendering the game scene.
    drawScene(gameScene, gameBoard.board);

    %DO GAME LOGIC HERE.
    gameBoard = tetro.move('d');
    
    key_down = guidata(gameScene.my_figure);
    if(key_down)
    
        if isequal(key_down, 'a') || isequal(key_down, 'leftarrow')
            gameBoard = tetro.move('l');
        
        elseif isequal(key_down, 'd') || isequal(key_down, 'rightarrow')
            gameBoard = tetro.move('r');
            
        elseif isequal(key_down, 'f1')
            tetro.MaxTicsUntilFall = tetro.MaxTicsUntilFall - 1;
            fprintf("[DEBUG]: %i\n", tetro.MaxTicsUntilFall);
        
        elseif isequal(key_down, 'f2')
            tetro = Tetromino();
        
        elseif isequal(key_down, 'escape')
            close(gameScene.my_figure);
            playing = false;
        
        end
        
    end

    %This pause limits the fps based on the framerate variable.
    pause(1/framerate-toc);
    %fprintf("Framerate: %f\n", 1/toc); %Unccoment this line to see framerate.
end

%TODO UNCCOMENT: clear; clc;

%Handels window close events. (When the window is closed this function is called).
function closeCallback(src, ~)
    assignin('base', 'playing', false);
    delete(src);
end
