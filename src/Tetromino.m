classdef Tetromino < handle
%TETROMINO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type
        color
        locations
        left
        right
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
                    obj.bottom = 1;
 
                case 2 %Square Piece
                    obj.color = 6;
                    obj.locations = [[1,5],[1,6],[2,5],[2,6]];
                    
                    obj.left = 5;
                    obj.right = 6;
                    obj.bottom = 2;
 
                case 3 %Left L Piece
                    obj.color = 3;
                    obj.locations = [[1,4],[2,4],[2,5],[2,6]];
                    
                    obj.left = 4;
                    obj.right = 6;
                    obj.bottom = 2;
 
                case 4 %Right L Piece
                    obj.color = 4;
                    obj.locations = [[1,6],[2,4],[2,5],[2,6]];
                    
                    obj.left = 4;
                    obj.right = 6;
                    obj.bottom = 2;
 
                case 5 %Left Zig-Zag Piece
                    obj.color = 2;
                    obj.locations = [[1,5],[1,6],[2,4],[2,5]];
                    
                    obj.left = 4;
                    obj.right = 7;
                    obj.bottom = 2;
 
                case 6 %Right Zig-Zag Piece
                    obj.color = 5;
                    obj.locations = [[1,4],[1,5],[2,5],[2,6]];
                    
                    obj.left = 4;
                    obj.right = 6;
                    obj.bottom = 2;
                case 7 %T-Shape Piece
                    obj.color = 7;
                    obj.locations = [[1,5],[2,4],[2,5],[2,6]];
                    
                    obj.left = 4;
                    obj.right = 6;
                    obj.bottom = 2;
            end
            
        end
        
        function result = move(obj, dir, gameboard)
            pre = obj;
            
            switch dir
                case 'l' % move left
                    if obj.left - 1 >= 1
                        for i = 2:2:8
                            obj.locations(i) = obj.locations(i) - 1;
                        end
                        obj.left = obj.left - 1;
                        obj.right = obj.right - 1;
                        
                        result = gameboard.update(pre, obj);
                    end
                case 'd' % move down
                    if obj.ticsUntilFall > 0
                        obj.ticsUntilFall = obj.ticsUntilFall - 1;
                        return;
                    else
                        obj.ticsUntilFall = obj.MaxTicsUntilFall;
                    end
                    
                    if obj.bottom + 1 <= 20
                        for i = 1:2:8
                            obj.locations(i) = obj.locations(i) + 1;
                        end
                        obj.bottom = obj.bottom + 1;
                    
                        result = gameboard.update(pre, obj);
                    end
                case 'r' % move right
                    if obj.right + 1 <= 10
                        for i = 2:2:8
                            obj.locations(i) = obj.locations(i) + 1;
                        end
                        obj.left = obj.left + 1;
                        obj.right = obj.right + 1;
                        
                        result = gameboard.update(pre, obj);
                    end

            end
        end

    end
end
