% Bad practice - disable warnings
warning('off','all');

skip = 40;

% Files to load, in chronological order.
numFiles = num_files('boundaries','.txt');
fnames = {};
fnames{1} = 'boundaries/initBoundary.txt';
for i = 1 : numFiles-1;
    fnames{end+1} = ['boundaries/', num2str(i), '.txt'];
end

figure
hold on

colors = viridis(round(1.5*length(fnames))); colors = colors(1:length(fnames),:);

for i = 1 : skip : length(fnames)
  dat = readtable(fnames{i});
  plot(dat{:,1},dat{:,2},'Color',colors(i,:),'LineWidth',1)
end

axis equal
axis off

s = split(pwd,filesep); s = s{end};
exportgraphics(gcf,[s,'_boundary.png'])