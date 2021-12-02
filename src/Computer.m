function [tetro,final] = Computer(tetro,orig)
%COMPUTER Summary of this function goes here
%   Detailed explanation goes here
    
%     bestMove = [randi(8) - 5, randi(4) - 1];
      
    bestMove = [0,0];
    copied = Tetromino().copytetro(tetro);
    for t = 1:4
        left = Tetromino().copytetro(copied);
        right = Tetromino().copytetro(copied);
        
        prevLeft = left.left;
        hitWall = false;
        numLeft = 0;
        bestHeight = 1;
        while ~hitWall
            gameboard = orig;
            [gameboard, ~] = left.move('l', gameboard);
            numLeft = numLeft + 1;
            curLeft = left.left;
            
            cleft = Tetromino().copytetro(left);
            while ~gameboard.collided
                [gameboard, gameboard.collided] = cleft.move('d', gameboard);
            end
            
            curHeight = cleft.top;
            if curHeight > bestHeight
                bestMove = [-numLeft, t];
                bestHeight = curHeight;
            end

            hitWall = curLeft == prevLeft;
            prevLeft = curLeft;
        end

        prevRight = right.right;
        hitWall = false;
        numRight = 0;
        while ~hitWall
            gameboard = orig;
            [gameboard, ~] = right.move('r', gameboard);
            numRight = numRight + 1;
            curRight = right.right;
            
            cright = Tetromino().copytetro(right);
            while ~gameboard.collided
                [gameboard, gameboard.collided] = cright.move('d', gameboard);
            end

            curHeight = cright.top;
            if curHeight > bestHeight
                bestMove = [numRight, t];
                bestHeight = curHeight;
            end

            hitWall = curRight == prevRight;
            prevRight = curRight;
        end

        gameboard = copied.rotate(gameboard);
    end
     
    final = orig;
    if bestMove(1) < 0 && bestMove(1) ~= 0
        for i = 1:abs(bestMove(1))
            [final, ~] = tetro.move('l', final);
        end
    else 
        for i = 1:abs(bestMove(1))
            [final, ~] = tetro.move('r', final);
        end
    end

    for i = 1:bestMove(2)
        final = tetro.rotate(final);
    end
end