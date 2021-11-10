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
            
            obj.type = randi(7);
            
            switch obj.type
                case 1
                    obj.color = 2; %Line   Piece
                    obj.locations = [[1,4],[1,5],[1,6],[1,7]];
                    obj.left = 4;
                    obj.right = 7;
                case 2
                    obj.color = 3; %Square Piece
                    obj.locations = [[1,5],[1,6],[2,5],[2,6]];
                    obj.left = 5;
                    obj.right = 6;
                case 3
                    obj.color = 4; %
                    obj.locations = [[1,4],[2,4],[2,5],[2,6]];
                    obj.left = 4;
                    obj.right = 6;
                case 4
                    obj.color = 2;
                    obj.locations = [[1,6],[2,4],[2,5],[2,6]];
                    obj.left = 4;
                    obj.right = 6;
                case 5
                    obj.color = 3;
                    obj.locations = [[1,5],[1,6],[2,4],[2,5]];
                    obj.left = 4;
                    obj.right = 7;
                case 6
                    obj.color = 4;
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

