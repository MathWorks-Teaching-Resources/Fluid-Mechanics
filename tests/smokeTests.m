% Run these tests with runMyTests
% All tests so far are on code expected to run without errors
% If/when we end up with a version that _should_ error, 
% please add it to this set of examples
classdef smokeTests < matlab.unittest.TestCase

    methods(Test)

        function runFunctions(testCase)
            % this function runs all the code in Functions.mlx
            % it also logs the final figure in the resulting output
            % document while closing the figure window on teardown
            import matlab.unittest.diagnostics.FigureDiagnostic;
            testCase.log("Running Functions.mlx")
            fig = figure;
            testCase.addTeardown(@close,fig)
            run("Functions.mlx")
            testCase.log(3,FigureDiagnostic(fig))
        end

        function runSharingCode(testCase)
            % this is the simplest possible logged version of a smoke test
            % that will run a file called "SharingCode.mlx"
            testCase.log("Running SharingCode.mlx")
            run("SharingCode.mlx");
        end

    end

end