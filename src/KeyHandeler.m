classdef KeyHandeler < handle
    properties (Constant)
        Keys = struct(  'upArrow', 1, 'downArrow', 2, 'leftArrow', 3, 'rightArrow', 4, ...
                        'w', 5, 'a', 6, 's', 7, 'd', 8);
    end

    properties
        currentKeys = false(14);
    end
    
    methods

        function onKeyPress(obj, ~, event)
            if(isequal(event.Key, 'downarrow'))
                obj.currentKeys(obj.Keys.downArrow) = true;
            elseif(isequal(event.Key, 'uparrow'))
                obj.currentKeys(obj.Keys.upArrow) = true;
            end
        end

        function onKeyRelease(obj, ~, event)
            if(isequal(event.Key, 'downarrow'))
                obj.currentKeys(obj.Keys.downArrow) = false;
            elseif(isequal(event.Key, 'uparrow'))
                obj.currentKeys(obj.Keys.upArrow) = false;
            end
        end

        function state = getKeyState(obj, key)
            state = obj.currentKeys(key);
        end
    end
end

