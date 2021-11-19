classdef TitleTet < handle
    %this object is a single tetromino block that is used in the title
    %screen
    properties
        color
        locationX
        locationY
        isOnBoard
        isLeft
    end
    
    methods
        function obj = TitleTet(isLeft)

            if nargin
                obj.isLeft = isLeft;
                obj.color = randi(7) + 1;
                obj.isOnBoard = false;
                obj.locationY = 1;
                obj.randX();
            end
         
        end

        function moveDown(obj)
            if obj.locationY == 23
                obj.locationY = 1;
                obj.randX();
                newColor(obj);

            else
                obj.locationY = obj.locationY + 1;
            end

        end

        function y = getY(obj)
            y = obj.locationY;
        end

        function x = getX(obj)
            x = obj.locationX;
        end

        function color = getColor(obj)
            color = obj.color;
        end

        function newColor(obj)
            obj.color = randi(7) + 1;
        end
        
        function randX(obj)
            if obj.isLeft
                obj.locationX = randi(5) + 1;
                obj.locationY = 1;
            else
                obj.locationX = randi(5) + 12;
                obj.locationY = 1;
            end
        end
    end
end