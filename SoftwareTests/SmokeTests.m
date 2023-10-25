% Run these tests with runMyTests
% All tests so far are on code expected to run without errors
% If/when we end up with a version that _should_ error, 
% please add it to this set of examples
classdef SmokeTests < matlab.unittest.TestCase
    
    properties
        rootProject
        results
    end


     methods (TestClassSetup)

        function setUpPath(testCase)
            
            try
                project = currentProject;
                testCase.rootProject = project.RootFolder;
                cd(testCase.rootProject)
            catch
                error("Load project prior to run tests")
            end
            
            testCase.log("Running in " + version)

        end % function setUpPath

        function setUpResults(testCase)
            files = dir(fullfile(testCase.rootProject,"Scripts","*.mlx"));
            testCase.results = struct;
            testCase.results.Name = strings(size(files));
            testCase.results.Passed = false(size(files));
            testCase.results.Time = zeros(size(files));
            testCase.results.Message = strings(size(files));
            for k = 1:length(files)
                testCase.results.Name(k) = string(files(k).name);
            end

        end % function setUpResults

    end % methods (TestClassSetup)

    methods(Test)

        function smokeTest(testCase)
            myFiles = testCase.results.Name;
            fid = fopen(fullfile("SoftwareTests","TestResults_"+release_version+".txt"),"w");
            for kTest = 1:1%length(myFiles)
                try
                    disp("Running " + myFiles(kTest))
                    tic
                    run(myFiles(kTest))
                    testCase.results.Time(kTest) = toc;
                    disp("Finished " + myFiles(kTest))
                    testCase.results.Passed(kTest) = true;
                    fprintf(fid,"%s,%s,%s\n",release_version,myFiles(kTest),"passed");
                catch ME
                    testCase.results.Time(kTest) = toc;
                    disp("Failed " + myFiles(kTest) + " because " + ...
                        newline + ME.message)
                    testCase.results.Message(kTest) = ME.message;
                    fprintf(fid,"%s,%s,%s\n",release_version,myFiles(kTest),"failed");
                end
                clearvars -except kTest testCase myFiles fid
            end
            fclose(fid);
            struct2table(testCase.results)
        end

    end

    methods (TestClassTeardown)

        function createBadge(testCase)

            % Find all the test result
            ResultFiles = dir("SoftwareTests"+filesep+"TestResults_*");


            % Read the results files
            TestResults = [];
            for kFiles = 1:size(ResultFiles,1)
                TestResults = [TestResults;...
                    readtable(fullfile(ResultFiles(kFiles).folder,ResultFiles(kFiles).name),...
                    Delimiter=",",ReadVariableNames=false,TextType="string")];
            end
            TestResults.Properties.VariableNames = ["Version","FileName","Results"];
            TestResults.Version = categorical(TestResults.Version);
            TestResults.FileName = categorical(TestResults.FileName);
            TestResults.Results = categorical(TestResults.Results);
            TestResults.Passed = TestResults.Results == "passed";

            % Summarize the table
            TestResults = pivot(TestResults,Rows="Version",DataVariable="Passed",Method=@(x) all(x));
            TestResults(~TestResults{:,2},:)= [];

            % Create JSON
            badgeInfo = struct;
            badgeInfo.schemaVersion = 1;
            badgeInfo.label = "tested with";
            badgeInfo.message = "";
            for i = 1:size(TestResults,1)
                if badgeInfo.message ~= ""
                    badgeInfo.message = badgeInfo.message + " | ";
                end
                badgeInfo.message = badgeInfo.message + string(TestResults.Version(i));
            end
            badgeInfo.color = "success";
            badgeJSON = jsonencode(badgeInfo);

            % Write JSON file out
            fid = fopen(fullfile("Images","TestedWith.json"),"w");
            fwrite(fid,badgeJSON);
            fclose(fid);
            
        end

        function closeAllFigure(testCase)
            close all force  % Close figure windows
            bdclose all      % Close Simulink models
        end

    end % methods (TestClassTeardown)

end