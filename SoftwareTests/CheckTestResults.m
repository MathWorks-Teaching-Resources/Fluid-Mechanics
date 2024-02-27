classdef CheckTestResults < matlab.unittest.TestCase

    properties (SetAccess = protected)
    end

    properties (ClassSetupParameter)
        Project = {''};
    end

    properties (TestParameter)
        Results
    end


    methods (TestParameterDefinition,Static)

        function Results = GetWindows(Project)
            RootFolder = currentProject().RootFolder;
            Results = dir(fullfile(RootFolder,"SoftwareTests","TestResults*.txt"));
            Results = {Results.name};
        end

    end

    methods (TestClassSetup)

        function SetUpSmokeTest(testCase,Project)
            try
               currentProject;   
            catch
                error("Project is not loaded.")
            end
        end

    end

    methods(Test)

        function CheckResults(testCase,Results)
            Results = readtable(Results,TextType="string");
            testCase.verifyTrue(all(Results.Passed));
        end

    end

end