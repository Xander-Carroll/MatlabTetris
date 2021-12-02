%This class controls the blocks that fall on the title screen
classdef TitleTet < handle
    
    properties 
        color
        locationX
        locationY
        isOnBoard
        isLeft
    
    end
    
    methods
        %creates the object
        function obj = TitleTet(isLeft)

            if nargin %if there are input parameters
                obj.isLeft = isLeft;
                obj.color = randi(7) + 1;
                obj.locationY = 1;
                obj.randX();
            end
         
        end

        %moves the object down 1 space
        function moveDown(obj)
            if obj.locationY == 25
                obj.locationY = 1;
                obj.randX();
                newColor(obj);

            else
                obj.locationY = obj.locationY + 1; %move down
            end

        end

        %returns the Y value of the object
        function y = getY(obj)
            y = obj.locationY;
        end

        %returns the x value of the object
        function x = getX(obj)
            x = obj.locationX;
        end
        
        %returns the color of the object
        function color = getColor(obj)
            color = obj.color;
        end
        
        %give the object a new color
        function newColor(obj)
            obj.color = randi(7) + 1;
        end
        
        %gives the object a new random x coordinate
        function randX(obj)
            if obj.isLeft
                obj.locationX = randi(6);
                obj.locationY = 1;
            else
                obj.locationX = randi(6) + 12;
                obj.locationY = 1;
            end
        end
    end
end