% Create the test suite with SmokeTest and Function test if they exist
Suite = testsuite("SmokeTests");
Suite = [Suite;testsuite("FunctionTests")];

% Create a runner with no plugins
Runner = matlab.unittest.TestRunner.withNoPlugins;

% Run the test suite
Results = Runner.run(Suite);

% Format the results in a table and save them
ResultsTable = table(Results')
writetable(ResultsTable,fullfile("SoftwareTests","TestResults_"+release_version+".txt"));

% Assert success of test
assertSuccess(Results);
