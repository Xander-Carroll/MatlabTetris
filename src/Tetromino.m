classdef Tetromino < handle

    properties
        %Used to control tetromino appearance/movement.
        type
        color

        %Used to keep the location of the piece and keeps it from moving out of the board.
        locations
        left
        right
        top
        bottom
        pivot
        rstate = 0;

        %Used to control tetromino speed.
        maxTicsUntilFall = 5;
        ticsUntilFall = 5;
    end

    methods
        %Picks a random piece from the list of 7 and initializes the class properities based on the piece picked.
        function obj = Tetromino(type)

            %Used to pick a random tetromino piece.
            if nargin > 0
                obj.type = type;
            
            else
                obj.type = randi(7);
            end
            
            switch obj.type
                case 1 %Line Piece
                    obj.color = 8;
                    obj.locations = [[1,4],[1,5],[1,6],[1,7]];
                    
                    obj.left = 4;
                    obj.right = 7;
                    obj.top = 1;
                    obj.bottom = 1;
                    obj.pivot = [1.5, 5.5];
 
                case 2 %Square Piece
                    obj.color = 6;
                    obj.locations = [[1,5],[1,6],[2,5],[2,6]];
                    
                    obj.left = 5;
                    obj.right = 6;
                    obj.top = 1;
                    obj.bottom = 2;
                    obj.pivot = [1.5,5.5];
 
                case 3 %Left L Piece
                    obj.color = 3;
                    obj.locations = [[1,4],[2,4],[2,5],[2,6]];
                    
                    obj.left = 4;
                    obj.right = 6;
                    obj.top = 1;
                    obj.bottom = 2;
                    obj.pivot = [2,5];
 
                case 4 %Right L Piece
                    obj.color = 4;
                    obj.locations = [[1,6],[2,4],[2,5],[2,6]];
                    
                    obj.left = 4;
                    obj.right = 6;
                    obj.top = 1;
                    obj.bottom = 2;
                    obj.pivot = [2,5];
 
                case 5 %Left Zig-Zag Piece
                    obj.color = 2;
                    obj.locations = [[1,5],[1,6],[2,4],[2,5]];
                    
                    obj.left = 4;
                    obj.right = 6;
                    obj.top = 1;
                    obj.bottom = 2;
                    obj.pivot = [2,5];
 
                case 6 %Right Zig-Zag Piece
                    obj.color = 5;
                    obj.locations = [[1,4],[1,5],[2,5],[2,6]];
                    
                    obj.left = 4;
                    obj.right = 6;
                    obj.top = 1;
                    obj.bottom = 2;
                    obj.pivot = [2,5];

                case 7 %T-Shape Piece
                    obj.color = 7;
                    obj.locations = [[1,5],[2,4],[2,5],[2,6]];
                    
                    obj.left = 4;
                    obj.right = 6;
                    obj.top = 1;
                    obj.bottom = 2;
                    obj.pivot = [2,5];

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
                        
                        obj.pivot(2) = obj.pivot(2) - 1;
                    end
                case 'd' % move down
                    if obj.ticsUntilFall > 0
                        obj.ticsUntilFall = obj.ticsUntilFall - 1;
                        return;
                    else
                        obj.ticsUntilFall = obj.maxTicsUntilFall;
                    end
                    
                    if obj.bottom + 1 <= 23 && ~collided
                        for i = 1:2:8
                            obj.locations(i) = obj.locations(i) + 1;
                        end
                        obj.top = obj.top + 1;
                        obj.bottom = obj.bottom + 1;

                        obj.pivot(1) = obj.pivot(1) + 1;
                    end
                case 'r' % move right
                    if obj.right + 1 <= 10 && ~collided
                        for i = 2:2:8
                            obj.locations(i) = obj.locations(i) + 1;
                        end
                        obj.left = obj.left + 1;
                        obj.right = obj.right + 1;

                        obj.pivot(2) = obj.pivot(2) + 1;
                    end
            end

            gameboard = gameboard.updateTetrisPiece(pre, obj);
        end
        
        %Function copies all properties of one tetro to another
        function obj = copytetro(obj, tetro) 
            obj.type = tetro.type;
            obj.color = tetro.color;
            obj.locations = tetro.locations;
            obj.left = tetro.left;
            obj.right = tetro.right;
            obj.top = tetro.top;
            obj.bottom = tetro.bottom;
            obj.pivot = tetro.pivot;
            obj.rstate = tetro.rstate;

            obj.maxTicsUntilFall = tetro.maxTicsUntilFall;
            obj.ticsUntilFall = tetro.ticsUntilFall;
        end
        
        %Function used to rotate the tetris piece
        function gameboard = rotate(obj, gameboard)
            if obj.type == 2; return; end % lol?
            
            % dir = 1; //only to be used if we decide to rotate in both
            %            directions, commented out for now.
                
            pre = Tetromino().copytetro(obj);
            loc = obj.locations;
            board = gameboard.board;

            % set the rotation point based on tetromino type
            midx = obj.pivot(2);
            midy = obj.pivot(1);
            
            for i = 1:2:8 % rotate the pieces 90 counter clockwise
                temp = loc(i);
                loc(i) = loc(i + 1) - midx + midy;
                loc(i + 1) = -temp + midy + midx;
            end
            
            %adjust for if the piece has moved out of bounds
            loc = rotadjust(loc);

            % check to see if the piece has rotated where it can't be
            if obj.type ~= 1
                collided = checkRotCollide(obj, loc, board);
                
                switch obj.rstate
                    case 0
                        kicklist = [0,-1, 1,-1,-2, 0,-2,-1];
                    case 1
                        kicklist = [0, 1,-1, 1, 2, 0, 2, 1];
                    case 2
                        kicklist = [0, 1, 1, 1,-2, 0,-2, 1];
                    case 3
                        kicklist = [0,-1,-1,-1, 2, 0, 2,-1];
                end
                
                i = 1;
                while collided
                    temp = loc(1:1:8);
                    for x = 1:2:8
                       temp(x) = temp(x) + kicklist(i);
                       temp(x + 1) = temp(x + 1) + kicklist(i + 1);
                    end
       
                    temp = rotadjust(temp);                
                    collide = checkRotCollide(obj, temp, board);
                    
                    if ~collide
                       loc = temp;
                       break;
                    end
                    
                    i = i + 2;
                    if i > 7; break; end
                end
                
            else
                collided = checkRotCollide(obj, loc, board);
            end
            
            if collided; return; end
            
            obj.locations = loc;

            xs = obj.locations(2:2:8);
            ys = obj.locations(1:2:8);

            obj.top = min(ys);
            obj.bottom = max(ys);
            obj.left = min(xs);
            obj.right = max(xs);
            
            if obj.rstate ~= 3
                obj.rstate = obj.rstate + 1;
            else
                obj.rstate = 0;
            end

            gameboard = gameboard.updateTetrisPiece(pre, obj);
        end
    end
end

function adj = rotadjust(loc) % adjusts piece to stay in bounds
    xs = loc(2:2:8);
    ys = loc(1:2:8);

    if min(xs) < 1 % adjusting for left bounds
        dx = abs(1 - min(xs));
    elseif max(xs) > 10 % adjusting for right bounds
        dx = 10 - max(xs);
    else
        dx = 0;
    end

    if min(ys) < 1 % adjusting for ceiling
        dy = abs(1 - min(ys));
    elseif max(ys) > 23 % adjusting for floor
        dy = 23 - max(ys);
    else
        dy = 0;
    end

    for i = 1:2:8
        loc(i) = loc(i) + dy;
        loc(i + 1) = loc(i + 1) + dx;
    end
    
    adj = loc;
end

function collided = checkRotCollide(obj, loc, board)
    for i = 1:2:8
        cont = false;
        for x = 1:2:8 % self exclusion
            if (loc(i) == obj.locations(x) && loc(i + 1) == obj.locations(x + 1))
                cont = true; break;
            end
        end
        if cont; continue; end

        if board(loc(i), loc(i + 1)) ~= 1
            collided = true;
            return;
        end
    end
    
    collided = false;
end

function collided = checkCollide(obj, gameboard, dir)
    loc = obj.locations;   
    board = gameboard.board;
        
    xs = loc(2:2:8);
    ys = loc(1:2:8);
    if (min(xs) <= 1 && isequal(dir, 'l')) || (max(xs) >= 10 && isequal(dir, 'r'))
        collided = false;
        return;
    end
    if (max(ys) >= 23 && isequal(dir, 'd')) 
        collided = true;
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
                    collided = true;
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
                    collided = true;
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
                    collided = true;
                    return
                end
            end
    end
    collided = false;
end