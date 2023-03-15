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

        % This test attempt to open the mlx files
        function testMLX(testCase)
            files = dir(testCase.origProj.RootFolder+filesep+"**"+filesep+"*.mlx");
            for i = 1:size(files)
                f = string(files(i).folder)+filesep+string(files(i).name);
                f = matlab.desktop.editor.openDocument(f);
                f.closeNoPrompt;
            end
        end
        
        % This function test load all the MAT files
        function testMAT(testCase)
            files = dir(testCase.origProj.RootFolder+filesep+"**"+filesep+"*.mat");
            for i = 1:size(files)
                d = string(files(i).folder)+filesep+string(files(i).name);
                d = open(d);
                clear d
            end
        end

        % This function test load all the slx files
        function testSLX(testCase)
            files = dir(testCase.origProj.RootFolder+filesep+"**"+filesep+"*.slx");
            for i = 1:size(files)
                f = string(files(i).folder)+filesep+string(files(i).name);
                open_system(f)
                close_system(f)
            end
        end

        function runManOnTheMoon(testCase)
            % this is the simplest possible logged version of a smoke test
            % that will run a file called "SharingCode.mlx"
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