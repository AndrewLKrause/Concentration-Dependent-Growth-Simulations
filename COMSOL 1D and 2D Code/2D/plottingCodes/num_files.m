function counter = num_files(fdir, ext)
    counter = 0;
    fname = [fdir, filesep, num2str(counter+1), ext];
    while isfile(fname)
        counter = counter + 1;
        fname = [fdir, filesep, num2str(counter+1), ext];
    end
end