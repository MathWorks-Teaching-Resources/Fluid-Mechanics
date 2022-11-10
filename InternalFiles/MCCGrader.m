classdef MCCGrader

    methods

        function obj = MCCGrader(opts)

            arguments
                opts.Name     (1,1) string  = ""
                opts.Feedback (1,1) string  = ""
                opts.Reset    (1,1) logical = false
                opts.Code     (1,1) uint8   = 0
            end

            persistent name;
            persistent feedback;
            persistent isinit;
            if isempty(name)
                name = "";                
            end
            if isempty(feedback)
                feedback = "";
            end
            if isempty(isinit)
                isinit = false;
            end

            if ( opts.Code ~= 0 )
                RegisterEntry = true;
            else
                RegisterEntry = false;
            end
            
            if ( opts.Name ~= "" )
                name = opts.Name;
                isinit = true;
                RegisterEntry = false;
            end
            if ( opts.Feedback ~= "" )
                feedback = opts.Feedback;
                RegisterEntry = false;
            end
            if ( opts.Reset )
                name = [];
                feedback = [];
                RegisterEntry = false;
            end
            
            [~,File,Ext] = fileparts(matlab.desktop.editor.getActiveFilename);
            if ( RegisterEntry )
                Stack = dbstack();
                Timestamp = datetime;
                if size(Stack, 1) > 1
                    Location = string(Stack(2).name);
                else 
                    Location = string(Stack.name);
                end
                Code = opts.Code;
                Release = matlabRelease.Release;
                Platform = string(computer);
                
                
                Entry = table(Timestamp, Location, Code, Release, Platform)
            end


        end

    end

end