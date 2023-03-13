% Run these tests with runMyTests
% All tests so far are on code expected to run without errors
% If/when we end up with a version that _should_ error, 
% please add it to this set of examples
classdef smokeTests < matlab.unittest.TestCase

    properties
        fc
        origProj
    end

    methods (TestClassSetup)
        function setUpPath(testCase)
            testCase.origProj = matlab.project.rootProject;

            testCase.fc = fullfile(pwd);
            rootDirName = extractBefore(testCase.fc,"tests");
            openProject(rootDirName);
        end % function setUpPathgit a
    end % methods (TestClassSetup)

    methods(Test)

        function runManOnTheMoon(testCase)
            testCase.log("Running ManOnTheMoon.mlx")
            ManOnTheMoon
        end

        function runPressureVelocity(testCase)
            testCase.log("Running PressureVelocity.mlx")
            PressureVelocity
        end

        function runCarbonNeutral(testCase)
            testCase.log("Running CarbonNeutral.mlx")
            CarbonNeutral
        end

        function runIngenuity(testCase)
            testCase.log("Running Ingenuity.mlx")
            Ingenuity
        end

        function runInternalFlow(testCase)
            testCase.log("Running InternalFlow.mlx")
            InternalFlow
        end

    end

    methods (TestClassTeardown)
        function resetPath(testCase)

            if isempty(testCase.origProj)
                close(currentProject)
            else
                openProject(testCase.origProj.RootFolder)
            end

            cd(testCase.fc)
        end

    end % methods (TestClassTeardown)

end