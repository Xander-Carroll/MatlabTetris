classdef Tetromino
    %TETROMINO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type
        color
        locations
        left
        right
        bottom
    end
    
    methods
        function obj = Tetromino()
            %TETRAMINO Construct an instance of this class
            %   Detailed explanation goes here
            
            obj.type = randi(6);
            
            switch obj.type
                case 1 %Line Piece
                    obj.color = 4;
                    obj.locations = [[1,4],[1,5],[1,6],[1,7]];
                    obj.left = 4;
                    obj.right = 7;
                case 2 %Square Piece
                    obj.color = 6;
                    obj.locations = [[1,5],[1,6],[2,5],[2,6]];
                    obj.left = 5;
                    obj.right = 6;
                case 3 %Left L Piece
                    obj.color = 7;
                    obj.locations = [[1,4],[2,4],[2,5],[2,6]];
                    obj.left = 4;
                    obj.right = 6;
                case 4 %Right L Piece
                    obj.color = 3;
                    obj.locations = [[1,6],[2,4],[2,5],[2,6]];
                    obj.left = 4;
                    obj.right = 6;
                case 5 %Left Zig-Zag Piece
                    obj.color = 2;
                    obj.locations = [[1,5],[1,6],[2,4],[2,5]];
                    obj.left = 4;
                    obj.right = 7;
                case 6 %Right Zig-Zag Piece
                    obj.color = 5;
                    obj.locations = [[1,4],[1,5],[2,5],[2,6]];
            end
            
        end
        
        function obj = move(obj)
            
            obj.locations = [];
            
        end
        
        function [locs] = retLocs(obj)
            locs = obj.locations;
        end
    end
end

