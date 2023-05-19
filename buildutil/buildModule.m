function buildModule

    % Set an earliest usable MATLAB version check here
    if isMATLABReleaseOlderThan("R2023a")
        error("Fluid-Mechanics:releaseFromLatest","This module only works on R2023a or later.") %#ok<*CTPCT>
    end
    
    prj = currentProject;
    rootDir = prj.RootFolder;

    % Check for code issues
    codecheckModule(rootDir);
    disp("code check complete.");

    releaseInfo = matlabRelease;

    % Run unit tests and capture code coverage
    testModule("ReportSubdirectory",releaseInfo.Release,"ModuleName","fluid-mechanics","RunFunctionTests",false)

    % Update Badges for GitHub.com
    badgesforModule(rootDir)
    disp("test complete");

end
