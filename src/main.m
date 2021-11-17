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

%Used to determine if a piece has landed (and therefore a new piece should be made).
collided = false;
collideTimerMax = 5;
collideTimer = 5;

%Initializing the game scene. The scene must be drawn once before the game loop and before callback methods can be set.
drawScene(gameScene, gameBoard.getVisibleBoard());

%Setting a callback method for the window close event. (Handeled with function at the bottom of the script).
set(gameScene.my_figure, 'CloseRequestFcn', @closeCallback);

%The speed at which the pieces fall. A smaller speed make faster pieces.
pieceSpeed = 5;

%Creating the first piece. Once this piece lands a new piece is made.
tetro = Tetromino(); tetroLoc = tetro.locations;

%Used to create an if branch that will execute only a single time on a keypress.
wasKeyJustPressed = 0;

%Starting the main game loop. 
%playing will become false when the game window is closed (Or escape is pressed).
playing = true;
while playing
    tic;

    %Rendering the game scene.
    drawScene(gameScene, gameBoard.getVisibleBoard());

    %Moving the tetromino down.
    [gameBoard, collided] = tetro.move('d', gameBoard);

    %Handling user input.
    key_down = guidata(gameScene.my_figure);
    if(key_down)
        wasKeyJustPressed = key_down;

        %Left piece movement
        if isequal(key_down, 'a') || isequal(key_down, 'leftarrow')
            [gameBoard, ~] = tetro.move('l', gameBoard);
        
        %Right piece movement
        elseif isequal(key_down, 'd') || isequal(key_down, 'rightarrow')
            [gameBoard, ~] = tetro.move('r', gameBoard);
        
        %Start piece fast fall
        elseif isequal(key_down, 's') || isequal(key_down, 'downarrow')
            tetro.maxTicsUntilFall = 0;
            tetro.ticsUntilFall = 0;   
        
        %Escape key to close game
        elseif isequal(key_down, 'escape')
            close(gameScene.my_figure);
            playing = false;
        
        %TODO REMOVE: Temporary key input used for debuging.
        elseif isequal(key_down, 'f1')
            pieceSpeed = pieceSpeed - 1;
            tetro.maxTicsUntilFall = pieceSpeed;
            fprintf("[DEBUG]: New Piece Speed = %i\n", pieceSpeed);
        elseif isequal(wasKeyJustPressed, 'f2')
            tetro = Tetromino();
            fprintf("[DEBUG]: Piece Created\n");
        end
        
    else

        %When the down key is released stop fast fall.
        if isequal(wasKeyJustPressed, 's') || isequal(wasKeyJustPressed, 'downarrow')
            tetro.maxTicsUntilFall = pieceSpeed;
            tetro.ticsUntilFall = pieceSpeed;
        end

        wasKeyJustPressed = 0;
    end

    %Once a piece has landed it is determined if the player has lost, if any lines have been cleared, and creates a new tetro.
    if (collided)
        if(collideTimer > 0)
            collideTimer = collideTimer - 1;
        else
            collideTimer = collideTimerMax;

            if (gameBoard.isGameOver())
                close(gameScene.my_figure);
                playing = false;
            else
                tetro = Tetromino();
                collided = false;

                gameBoard = gameBoard.clearCompleteRows();
            end

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