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
        end % function setUpPath
    end % methods (TestClassSetup)

    methods(Test)

        function runManOnTheMoon(testCase)
            % this is the simplest possible logged version of a smoke test
            % that will run a file called "SharingCode.mlx"
            testCase.log("Running ManOnTheMoon.mlx")
            ManOnTheMoon
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