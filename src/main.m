%RUN THIS FILE TO START THE GAME

%Developed by Danny, Matt, and Xander. Engineering 1181 SDP.

clear; clc;
fprintf("Engineering 1181 SDP: Tetris V:0.0.1\n");
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%The main game scene. This will need to be drawn to every frame.
gameScene = simpleGameEngine('../res/Tiles.png',32,32,5);

%The main game board. Initialized to a blank board.
gameBoard = ones(24,10);

%Creating a test piece.
gameBoard(3,5) = 2; gameBoard(3,6) = 3; gameBoard(3,7) = 4; gameBoard(4,6) = 2;

%Initializing the game scene. The scene must be drawn once before the game loop.
drawScene(gameScene, gameBoard);

%Creating the main game loop. 
%Due to an edit in simpleGameEngine.m playing=false when the x button is pressed.
playing = true;
while playing
    tic;

    %Rendering the game scene.
    drawScene(gameScene, gameBoard);

    
    %DO GAME LOGIC HERE.


    %This pause gets a consistent 0.1 second game loop.
    pause(0.1-toc);
    
    %disp(toc);  %UNCOMMENT THIS LINE TO SEE THAT WE ARE RUNNING AT 1 LOOP EVERY 0.1 SECONDS.
end

clear; clc;
