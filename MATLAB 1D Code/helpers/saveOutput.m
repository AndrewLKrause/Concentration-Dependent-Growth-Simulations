function saveOutput(dirs, output)

    % If the output folder doesn't exist, create it. We do this for all
    % levels.

    folder = '.';
    for name = dirs
        folder = [folder, filesep, name{1}];
        if ~exist(folder, 'dir')
            mkdir(folder)
        end
    end

    save([folder,filesep,'output.mat'], 'output')

end