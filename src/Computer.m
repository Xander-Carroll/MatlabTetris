function copied = Computer(tetro,gameboard)
    
    board = gameboard.board;

    heights = ones(10,1).* 24;
    for x = 1:10
        for y = 1:23
            if board(y,x) ~= 1
                heights(x) = y;
                break
            end
        end
    end
    
    copied = tetro.copytetro(tetro);

    bestEmpty = 100; bestHeight = 1; xind = 1; rstate = 0;
    for rot = 1:4
        ys = tetro.locations(1:2:8);
        xs = tetro.locations(2:2:8);
        
        width = tetro.right + 1 - tetro.left;
    
        tHeights = zeros(width,1);
        for i = 1:4
            ind = xs(i) - tetro.left + 1;
            if ys(i) > tHeights(ind)
                tHeights(ind) = ys(i);
            end
        end
        
        range = (10 - width + 1);
    
        arrEmpty = zeros(range,1);
        arrHeights = zeros(range,1);
        for i = 1:range
            th = ones(width,1).*24;
            emptySpace = zeros(width, 1);
            for x = 1:width
                th(x) = heights(i + x - 1) - tHeights(x);
            end
            curHeight = min(th);
            
            for x = 1:width
                emptySpace(x) = heights(i + x - 1) - curHeight - tHeights(x);  
            end
            arrEmpty(i) = sum(emptySpace);
            arrHeights(i) = curHeight;
        end
        
        curxind = 1;
        for i = 1:range
            if arrEmpty(i) < arrEmpty(curxind)
                curxind = i;
            elseif arrEmpty(i) == arrEmpty(curxind) && arrHeights(i) > arrHeights(curxind)
                curxind = i;
            end
        end

        if bestEmpty > arrEmpty(curxind)
            xind = curxind;
            rstate = tetro.rstate;
            bestEmpty = arrEmpty(xind);
            bestHeight = arrHeights(xind);
        elseif bestEmpty == arrEmpty(curxind) && arrHeights(curxind) > bestHeight
            xind = curxind;
            rstate = tetro.rstate;
            bestEmpty = arrEmpty(xind);
            bestHeight = arrHeights(xind);
        end
        
        gameboard = tetro.rotate(gameboard);
    end
    
    while copied.rstate ~= rstate
        gameboard = copied.rotate(gameboard);
    end

    delta = xind - copied.left;
    for i = 2:2:8
        copied.locations(i) = copied.locations(i) + delta; 
    end

    newxs = copied.locations(2:2:8);
    copied.left = min(newxs);
    copied.right = max(newxs);
end