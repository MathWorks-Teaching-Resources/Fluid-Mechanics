% Run these tests with runMyTests
%
% Alternately, run these tests with 
% results = runtests(tests)
% table(results)
classdef functionTests < matlab.unittest.TestCase

    methods(Test)
        function checkBuildWord(testCase)
            % Tests that the expected strings are generated
            % given a particular random seed of 123
            % Note that the expected results are hard-coded into the test
            actual = strings(1,5);
            rng(123)
            for k = 1:5
                idx = [1 5 10 20 30];
                actual(k) = buildWord(idx(k));
            end
            expected = ["s" "hfosl" "zrmkislbkt" "eennqwspsijfhqcllmli" ...
                "lxynqdikwgmznpdvpoihkrwnrpqrvc"];
            verifyTrue(testCase,all(actual==expected))
        end

        function checkBuildWord2(testCase)
            % Test that the expected strings are generated
            % given a particular random seed of 123
            % Note that the expected results are loaded into the test
            %   from an additional file expectedBW2.mat containing
            %   the hand-checked expected output from the script
            actual = strings(1,5);
            rng(321)
            for k = 1:5
                idx = [1 5 10 20 30];
                actual(k) = buildWord2(idx(k));
            end
            load expectedBW2.mat
            verifyTrue(testCase,all(actual==expectedBW2))
        end

        function runCheckExercise5(testCase)
            % this functions checks each of three possible outputs for 
            % checkExercise5 given different input values
            roundedOut = checkExercise5(1.1022);
            correctOut = checkExercise5(fzero(@(t) cos(t)-t*exp(-sin(t)),1));
            incorrectOut = checkExercise5(0);
            verifyEqual(testCase,[roundedOut correctOut incorrectOut], [0.5 1 0])
        end

        function runShowTaylor(testCase)
            % runShowTaylor has no output, but generates a plot
            % this function compares the generated plot to a saved
            % version that was checked by hand
            fig = figure;
            testCase.addTeardown(@close,fig)
            showTaylor(@cos,12,[-2*pi 2*pi], 0)
            actualTaylor = print("-RGBImage");
            load showTaylorExpected.mat
            verifyEqual(testCase,actualTaylor,expectedTaylor)
        end


    end % methods

end % classdef