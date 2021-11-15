classdef Tetromino < handle
    properties
        %Used to control tetromino appearance/movement.
        type
        color
        locations
        left
        right

        top
        bottom

        %Used to control tetromino speed.
        maxTicsUntilFall = 5;
        ticsUntilFall = 5;
    end

    methods
        function obj = Tetromino()

            %Used to pick a random tetromino piece.
            obj.type = randi(7);
            
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
                    obj.color = 3;
                    obj.locations = [[1,6],[2,4],[2,5],[2,6]];
                    
                    obj.left = 4;
                    obj.right = 6;
                    obj.top = 1;
                    obj.bottom = 2;
 
                case 5 %Left Zig-Zag Piece
                    obj.color = 2;
                    obj.locations = [[1,5],[1,6],[2,4],[2,5]];
                    
                    obj.left = 4;
                    obj.right = 6;
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
        
        %Function used to move the tetris piece left right or down.
        function [gameboard, collided] = move(obj, dir, gameboard)
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
                        obj.ticsUntilFall = obj.maxTicsUntilFall;
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
    
            obj.maxTicsUntilFall = tetro.maxTicsUntilFall;
            obj.ticsUntilFall = tetro.ticsUntilFall;
        end

    end
end

function isCollide = checkCollide(obj, gameboard, dir)
    loc = obj.locations;   
    board = gameboard.board;
        
    xs = loc(2:2:8);
    ys = loc(1:2:8);
    if (min(xs) == 1 && isequal(dir, 'l')) || (max(xs) == 10 && isequal(dir, 'r'))
        isCollide = false;
        return;
    end
    if (max(ys) == 20 && isequal(dir, 'd')) 
        isCollide = true;
        return;
    end
    switch dir
        case 'l'
            for i = 1:2:8
                cont = false;
                for x = 1:2:8 % excluding itself
                    if x == i; continue; end
                    if (loc(i) == loc(x)) && (loc(i + 1) - 1 == loc(x + 1))
                        cont = true;
                    end
                end
                if cont; continue; end
                if board(loc(i), loc(i+1) - 1) ~= 1
                    isCollide = true;
                    return
                end
            end
        
        case 'd'
            for i = 1:2:8
                cont = false;
                for x = 1:2:8 % excluding itself
                    if x == i; continue; end
                    if (loc(i) + 1 == loc(x)) && (loc(i + 1) == loc(x + 1))
                        cont = true;
                    end
                end
                if cont; continue; end
                
                if board(loc(i) + 1, loc(i+1)) ~= 1
                    isCollide = true;
                    return
                end
            end
        
        case 'r'
            for i = 1:2:8
                cont = false;
                for x = 1:2:8 % excluding itself
                    if x == i; continue; end
                    if (loc(i) == loc(x)) && (loc(i + 1) + 1 == loc(x + 1))
                        cont = true;
                    end
                end
                if cont; continue; end
                
                if board(loc(i), loc(i+1) + 1) ~= 1
                    isCollide = true;
                    return
                end
            end
    end
    isCollide = false;
end