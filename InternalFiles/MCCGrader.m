classdef MCCGrader

    properties (Access = private)
        m_numquery (1,1) int16 {mustBeGreaterThanOrEqual(m_numquery, 0)} = 0
        m_numright (1,1) int16 {mustBeGreaterThanOrEqual(m_numright, 0)} = 0
        m_name     (1,1) string = "NaN - NotAName"
    end
    
    methods

        function obj = MCCGrader(varargin)
            
            if nargin == 1
                in = varargin{1};
                if isstring(in)
                    obj.m_name = obj.RegisterName(in);
                elseif islogical(in)
                    [obj.m_numright, obj.m_numquery] = obj.RegisterAnswer(in);
                end
            end

        end

        function out = Report(obj, feedback)
            arguments
                obj (1,1) MCCGrader
                feedback (1,1) string = ""
            end
            m_name = obj.RegisterName
%             out = table(self.m_name, self.m_numright, self.m_numquery, feedback, ...
%                 'VariableNames',{'Name', 'Score', 'Questions', 'Feedback'});
        end

        function Reset(self)
            clear self.RegisterAnswer()
            clear self.RegisterName()
        end
    end

    methods (Static)

        function [r, n] = RegisterAnswer(cmp)
            arguments 
                cmp (1,1) logical = false
            end

            % Declare the persistent variable
            persistent numquery;
            persistent numright;
            if isempty(numquery)
                numquery = 0;
            end
            if isempty(numright)
                numright = 0;
            end
            
            % Increment the counter
            numquery = numquery+ 1;
            if cmp
                numright = numright + 1;
            end
            r = numright;
            n = numquery;
        end

        function n = RegisterName(name)

            persistent student;
            if isempty(student)
                student = name;
            end
            disp(student)
            n = student;
        end

    end
end