classdef KeyHandler < handle
    properties (Constant)
        Keys = struct(  'upArrow', 1, 'downArrow', 2, 'leftArrow', 3, 'rightArrow', 4, ...
                        'w', 5, 'a', 6, 's', 7, 'd', 8, 'escape', 9, 'key0', 10, 'key1', 11, 'key2', 12, 'f1', 13);
    end

    properties
        %A list of all used keys and their current state.
        currentKeys = false(10);
    end
    
    methods

        %This function is called anytime a key is pressed.
        function onKeyPress(obj, ~, event)
            if(isequal(event.Key, 'downarrow'))
                obj.currentKeys(obj.Keys.downArrow) = true;
            elseif(isequal(event.Key, 'uparrow'))
                obj.currentKeys(obj.Keys.upArrow) = true;
            elseif(isequal(event.Key, 'leftarrow'))
                obj.currentKeys(obj.Keys.leftArrow) = true;
            elseif(isequal(event.Key, 'rightarrow'))
                obj.currentKeys(obj.Keys.rightArrow) = true;
            end

            if(isequal(event.Key, 'w'))
                obj.currentKeys(obj.Keys.w) = true;
            elseif(isequal(event.Key, 'a'))
                obj.currentKeys(obj.Keys.a) = true;
            elseif(isequal(event.Key, 's'))
                obj.currentKeys(obj.Keys.s) = true;
            elseif(isequal(event.Key, 'd'))
                obj.currentKeys(obj.Keys.d) = true;
            end

            if(isequal(event.Key, 'escape'))
                obj.currentKeys(obj.Keys.escape) = true;
            elseif(isequal(event.Key, '0'))
                obj.currentKeys(obj.Keys.key0) = true;
            elseif(isequal(event.Key, '1'))
                obj.currentKeys(obj.Keys.key1) = true;
            elseif(isequal(event.Key, '2'))
                obj.currentKeys(obj.Keys.key2) = true;
            elseif(isequal(event.Key, 'f1'))
                obj.currentKeys(obj.Keys.f1) = true;
            end

        end

        %This function is called any time a key is released.
        function onKeyRelease(obj, ~, event)
            if(isequal(event.Key, 'downarrow'))
                obj.currentKeys(obj.Keys.downArrow) = false;
            elseif(isequal(event.Key, 'uparrow'))
                obj.currentKeys(obj.Keys.upArrow) = false;
            elseif(isequal(event.Key, 'leftarrow'))
                obj.currentKeys(obj.Keys.leftArrow) = false;
            elseif(isequal(event.Key, 'rightarrow'))
                obj.currentKeys(obj.Keys.rightArrow) = false;
            end

            if(isequal(event.Key, 'w'))
                obj.currentKeys(obj.Keys.w) = false;
            elseif(isequal(event.Key, 'a'))
                obj.currentKeys(obj.Keys.a) = false;
            elseif(isequal(event.Key, 's'))
                obj.currentKeys(obj.Keys.s) = false;
            elseif(isequal(event.Key, 'd'))
                obj.currentKeys(obj.Keys.d) = false;
            end

            if(isequal(event.Key, 'escape'))
                obj.currentKeys(obj.Keys.escape) = false;
            elseif(isequal(event.Key, '0'))
                obj.currentKeys(obj.Keys.key0) = false;
            elseif(isequal(event.Key, '1'))
                obj.currentKeys(obj.Keys.key1) = false;
            elseif(isequal(event.Key, '2'))
                obj.currentKeys(obj.Keys.key2) = false;
            elseif(isequal(event.Key, 'f1'))
                obj.currentKeys(obj.Keys.f1) = false;
            end
        end

        %This function can be used to poll keys for their current state.
        function state = getKeyState(obj, key)
            state = obj.currentKeys(key);
        end
    end
end

