function RunAllTest(GenerateReport,ShowReport,ReportFolder)
arguments
    GenerateReport (1,1) logical = false;
    ShowReport (1,1) logical = false;
    ReportFolder (1,1) string = "public";
end

import matlab.unittest.plugins.TestReportPlugin;

% Retrieve release version and architecture
Release = string(version('-release'));
if ispc
    Architecture = "Windows";
elseif isunix & ~ismac
    Architecture = "Linux";
elseif ismac
    Architecture = "Mac";
else
    error("Can't determine system architecture")
end

% Create the runner
if GenerateReport
    Runner = matlab.unittest.TestRunner.withTextOutput;
    Folder = fullfile(currentProject().RootFolder,ReportFolder);
    if ~isfolder(Folder)
        mkdir(Folder)
    else
        rmdir(Folder,'s')
        mkdir(Folder)
    end
    Plugin = TestReportPlugin.producingHTML(Folder,...
        "IncludingPassingDiagnostics",true,...
        "IncludingCommandWindowText",true,...
        "LoggingLevel",matlab.automation.Verbosity(1));
        Runner.addPlugin(Plugin);
else
    Runner = matlab.unittest.TestRunner.withNoPlugins;
end

% Create the test suite with SmokeTest and Function test if they exist
Suite = testsuite("SmokeTests");
% Suite = [Suite testsuite("FunctionTests")];

% Run the test suite
Results = Runner.run(Suite);
if ShowReport
    web(fullfile(Folder,"index.html"))
end

% Format the results in a table and save them
ResultsTable = table(Results')
FileName = fullfile("SoftwareTests","TestResults_"+Release+"_"+Architecture+".txt");
writetable(ResultsTable,FileName);

% Assert success of test
assertSuccess(Results);

end
