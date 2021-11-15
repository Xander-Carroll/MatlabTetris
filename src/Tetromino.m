classdef Tetromino < handle
%TETROMINO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type
        color
        locations
        left
        right

        top
        bottom

        MaxTicsUntilFall = 5;
        ticsUntilFall = 5;
    end

    methods
        function obj = Tetromino()
            %TETRAMINO Construct an instance of this class
            %   Detailed explanation goes here
            
            obj.type = randi(7);
            %obj.type = 1;
            
            switch obj.type
                case 1 %Line Piece
                    obj.color = 4;
                    obj.locations = [[1,4],[1,5],[1,6],[1,7]];
                    
                    obj.left = 4;
                    obj.right = 7;
                    obj.top = 1;
                    obj.bottom = 1;
 
                case 2 %Square Piece
                    obj.color = 6;
                    obj.locations = [[1,5],[1,6],[2,5],[2,6]];
                    
                    obj.left = 5;
                    obj.right = 6;
                    obj.top = 1;
                    obj.bottom = 2;
 
                case 3 %Left L Piece
                    obj.color = 3;
                    obj.locations = [[1,4],[2,4],[2,5],[2,6]];
                    
                    obj.left = 4;
                    obj.right = 6;
                    obj.top = 1;
                    obj.bottom = 2;
 
                case 4 %Right L Piece
                    obj.color = 4;
                    obj.locations = [[1,6],[2,4],[2,5],[2,6]];
                    
                    obj.left = 4;
                    obj.right = 6;
                    obj.top = 1;
                    obj.bottom = 2;
 
                case 5 %Left Zig-Zag Piece
                    obj.color = 2;
                    obj.locations = [[1,5],[1,6],[2,4],[2,5]];
                    
                    obj.left = 4;
                    obj.right = 7;
                    obj.top = 1;
                    obj.bottom = 2;
 
                case 6 %Right Zig-Zag Piece
                    obj.color = 5;
                    obj.locations = [[1,4],[1,5],[2,5],[2,6]];
                    
                    obj.left = 4;
                    obj.right = 6;
                    obj.top = 1;
                    obj.bottom = 2;

                case 7 %T-Shape Piece
                    obj.color = 7;
                    obj.locations = [[1,5],[2,4],[2,5],[2,6]];
                    
                    obj.left = 4;
                    obj.right = 6;
                    obj.top = 1;
                    obj.bottom = 2;

            end
            
        end
        
        function gameboard = move(obj, dir, gameboard)
            pre = Tetromino().copytetro(obj);
            
            collided = checkCollide(obj,gameboard,dir);

            switch dir
                case 'l' % move left
                    if obj.left - 1 >= 1 && ~collided
                        for i = 2:2:8
                            obj.locations(i) = obj.locations(i) - 1;
                        end
                        obj.left = obj.left - 1;
                        obj.right = obj.right - 1;
                    end
                case 'd' % move down
                    if obj.ticsUntilFall > 0
                        obj.ticsUntilFall = obj.ticsUntilFall - 1;
                        return;
                    else
                        obj.ticsUntilFall = obj.MaxTicsUntilFall;
                    end
                    
                    if obj.bottom + 1 <= 20 && ~collided
                        for i = 1:2:8
                            obj.locations(i) = obj.locations(i) + 1;
                        end
                        obj.top = obj.top + 1;
                        obj.bottom = obj.bottom + 1;
                    end
                case 'r' % move right
                    if obj.right + 1 <= 10 && ~collided
                        for i = 2:2:8
                            obj.locations(i) = obj.locations(i) + 1;
                        end
                        obj.left = obj.left + 1;
                        obj.right = obj.right + 1;
                    end
            end

            gameboard = gameboard.update(pre, obj);
        end
        
        function obj = copytetro(obj, tetro)
            obj.type = tetro.type;
            obj.color = tetro.color;
            obj.locations = tetro.locations;
            obj.left = tetro.left;
            obj.right = tetro.right;
            obj.top = tetro.top;
            obj.bottom = tetro.bottom;
    
            obj.MaxTicsUntilFall = tetro.MaxTicsUntilFall;
            obj.ticsUntilFall = tetro.ticsUntilFall;
        end

    end
end

function isCollide = checkCollide(obj, gameboard, dir)
            loc = obj.locations;   
            board = gameboard.board;
            
            if (max(loc) == 20) || (min(loc) == 1 && dir == 'l')
                isCollide = false;
                return;
            end
            
            switch dir
                case 'l'
                    for i = 1:2:8
                        if board(loc(i), loc(i+1) - 1) ~= 1 && board(loc(i), loc(i+1) - 1) ~= obj.color
                            isCollide = true;
                            return
                        end
                    end
                
                case 'd'
                    for i = 1:2:8
                        if board(loc(i) + 1, loc(i+1)) ~= 1 && board(loc(i) + 1, loc(i+1)) ~= obj.color
                            isCollide = true;
                            return
                        end
                    end
                
                case 'r'
                    for i = 1:2:8
                        if board(loc(i), loc(i+1) + 1) ~= 1 && board(loc(i), loc(i+1) + 1) ~= obj.color
                            isCollide = true;
                            return
                        end
                    end
            end

            isCollide = false;
end