%% Traverse the output directory and all subfolders, generating figures
%% wherever output.mat is found.
addpath(genpath('helpers'))

% Find all the relevant files
filelist = dir(fullfile('output', ['**',filesep,'*output.mat']));

failedPlots = zeros(length(filelist),1);
parfor fileInd = 1 : length(filelist)

    fprintf(['\r',repmat(' ',1,length(num2str(length(filelist)))*2 + 3)])
    fprintf(['\r',num2str(fileInd),' / ',num2str(length(filelist))])

    try
        filepath = filelist(fileInd).folder
        plotRun(filepath);
    catch exception
        failedPlots(fileInd) = 1;
    end

end


disp("Plots generated!")

if any(failedPlots)
    disp([num2str(sum(failedPlots)), ' plot(s) failed:'])
    for fileInd = 1 : length(filelist)
        if failedPlots(fileInd)
            disp(filelist(fileInd).folder)
        end
    end
end