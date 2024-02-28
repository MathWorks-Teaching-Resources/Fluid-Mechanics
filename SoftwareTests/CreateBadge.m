% Create the test suite with SmokeTest and Function test if they exist
Suite = testsuite("CheckTestResults");

% Create a runner with no plugins
Runner = matlab.unittest.TestRunner.withNoPlugins;

% Run the test suite
Results = Runner.run(Suite);

% Format the results in a table and save them
Results = table(Results');
Results.Release = extractBetween(string(Results.Name),"TestResults_","_");
Results.Archicteture = extractBetween(string(Results.Name),"_"+digitsPattern(4)+lettersPattern(1)+"_",".txt")

% Generate badges
Architectures = unique(Results.Archicteture);
for i = 1:length(Architectures)
    Arch = Architectures(i);
    ArchResults = Results(Results.Archicteture == Arch,:);
    ArchResults = ArchResults(ArchResults.Passed,:);
    Badge = struct;
    Badge.schemaVersion = 1;
    Badge.label = "Tested on "+Arch+" with:";
    if size(ArchResults,1) ~= 0
        Badge.color = "sucess";
        Badge.message = join(ArchResults.Release, " | ");
    else
        Badge.color = "critical";
        Badge.message = "failed";
    end
    Badge = jsonencode(Badge);
    writelines(Badge,fullfile("Images","BadgeTest_"+Arch+".json"));
end