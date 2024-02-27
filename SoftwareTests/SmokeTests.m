classdef SmokeTests < matlab.unittest.TestCase
    
    properties (ClassSetupParameter)
        Project = {''};
    end

    properties (TestParameter)
        Scripts;
        Models;
    end

    methods (TestParameterDefinition,Static)

        function Scripts = GetScriptName(Project)
            RootFolder = currentProject().RootFolder;
            Scripts = dir(fullfile(RootFolder,"Scripts","*.mlx"));
            Scripts = {Scripts.name};
        end

        function Models = GetModelName(Project)
            RootFolder = currentProject().RootFolder;
            Models = dir(fullfile(RootFolder,"Models","*.slx"));
            Models = {Models.name};
        end

    end

    methods (TestClassSetup)

        function SetUpSmokeTest(testCase,Project)
            try
               currentProject;  
            catch ME
                warning("Project is not loaded.")
            end
        end

    
    end


    
    methods(Test)

        function SmokeRunScript(testCase,Scripts)
            Filename = string(Scripts);
            switch (Filename)
                otherwise
                    SimpleScriptSmokeTest(testCase,Filename);
            end
        end

        function SmokeRunModel(testCase,Models)
            Filename = string(Models);
            switch (Filename)
                otherwise
                    SimpleModelSmokeTest(testCase,Filename);
            end
        end
            
    end


    methods (Access = private)

        function SimpleScriptSmokeTest(testCase,Filename)

            % Run the Smoke test
            RootFolder = currentProject().RootFolder;
            cd(RootFolder)
            disp(">> Running " + Filename);
            try
                run(fullfile("Scripts",Filename));
            catch ME
                testCase.verifyTrue(false,ME.message);
            end
            
            % Log the opened figures to the test reports
            Figures = findall(groot,'Type','figure');
            Figures = flipud(Figures);
            if size(Figures,1) ~= 0
                for f = 1:size(Figures,1)
                    FigDiag = matlab.unittest.diagnostics.FigureDiagnostic(Figures(f));
                    log(testCase,1,FigDiag);
                end
            end
            close all force

        end

        function SimpleModelSmokeTest(testCase,Filename)

            % Run the Smoke test
            RootFolder = currentProject().RootFolder;
            cd(RootFolder)
            disp(">> Running " + Filename);
            try
                sim(fullfile("Models",Filename));
            catch ME
                testCase.verifyTrue(false,ME.message);
            end

            % Close Simulink models
            bdclose all

        end

    end

end