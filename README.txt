-------------Matlab Tetris V1.1.0-------------

            Blake, Danny, and Xander

-------------Engineering 1181 SDP-------------


This README contains notes about the project structure and game for reference.

Firstly, the file src/main.m is the file that should be run to start the game.

Secondly, it is important to note that the game may not run as intended on the web
IDE version of Matlab. It is advised that the game be run on the download version
for best performance.

Thirdly, the download for the game should include a folder titled 'Matlab Tetris'.
Within this folder should be a src and res folder. These folders should not be moved
or renamed. The src folder includes all of the source code for the game while the res
folder contains assets such as art and sound files that are needed to run the game.

Fourthly, the controls of the game are as follows:

Title Screen:           Single Player:                  Multiplayer:                                All:
1 - Single Player       w/up - Rotate Piece             w/a/s/d - Player 1 Controls                 f2 - Show FPS Counter     
0 - Multiplayer         a/left arrow - Move Left        up/left/down/right - Player 2 Controls
esc - Close Game        s/down arrow - Fastfall         esc - Exit to Title Screen
f1 - Easter Egg         d/right arrow - Move Right
                        esc - Exit to Title Screen  

Fithly, It is woth mentioning that the AI player utilizes snap fall, a mechanic 
that the player was not given. This adds a layer of difficulty to the AI making 
this AI player a true challenge.

Finally, the purpose of the following files will be briefly summarized:

GameBoard.m - A class that can be used to create a grid that will hold pieces. 
    The class also contains various functions used for displaying the board.
KeyHandler.m - A class that can be used to gather key input from more than one
    key at a time.
main.m - The main script file that is used to start the game.
SimpleGameEngine.m - A file provided by the Engineering 1181 course used to display 
    sprites to a figure.
Tetromino.m - A class that can be used to create a random tetris piece, and contains
    various methods for moving and rotating the piece.
TitleTet.m - A class used to create the animations seen on the title screen.
