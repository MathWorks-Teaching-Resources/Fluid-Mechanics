function OpenOverview
% Open the overview file
locDir = pwd;
if contains(locDir,filesep+"MATLAB Drive")
    open("Navigation.mlx")
else
    open("Overview.html")
end

% % Close the current script
% open("OpenOverview.m")
close(matlab.desktop.editor.getActive)
end