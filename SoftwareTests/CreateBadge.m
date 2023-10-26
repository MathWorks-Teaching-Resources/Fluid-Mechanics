% Run these tests with runMyTests
% All tests so far are on code expected to run without errors
% If/when we end up with a version that _should_ error, 
% please add it to this set of examples
classdef CreateBadge < matlab.unittest.TestCase
    
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

        function readResults(testCase)
            Release = string([]);
            Passed = [];
            testCase.results = table(Release,Passed);

            ResultFiles = dir("SoftwareTests"+filesep+"TestResults_*");
            for kFiles = 1:size(ResultFiles)
                Results = readtable(fullfile(ResultFiles(kFiles).folder,ResultFiles(kFiles).name),...
                    Delimiter=",",TextType="string");
                Release = Results.Version(1);
                Passed = all(Results.Status == "passed");
                testCase.results(end+1,:) = table(Release,Passed)
            end
        end

    end % methods (TestClassSetup)

    methods(Test)

        function writeBadge(testCase)

            % Create JSON
            badgeInfo = struct;
            badgeInfo.schemaVersion = 1;
            badgeInfo.label = "tested with";
            badgeInfo.message = "";
            for i = 1:size(testCase.results,1)
                if testCase.results.Passed(i)
                    if badgeInfo.message ~= ""
                        badgeInfo.message = badgeInfo.message + " | ";
                    end
                    badgeInfo.message = badgeInfo.message + string(testCase.results.Release(i));
                end
            end
            badgeInfo.color = "success";
            badgeJSON = jsonencode(badgeInfo);

            % Write JSON file out
            fid = fopen(fullfile("Images","TestedWith.json"),"w");
            fwrite(fid,badgeJSON);
            fclose(fid);
            
        end

    end

end