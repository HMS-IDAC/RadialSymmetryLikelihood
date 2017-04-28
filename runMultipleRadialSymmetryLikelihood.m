% computes radialSymmetryLikelihood on all images in a folder;
% folder should contain only images to be analized, and nothing else,
%     except for the files generated (_AccSpace images and Results.csv)
% that is, the program will not read _AccSpace images and Results.csv,
%     but will try reading everything else in the folder
% outputs:
% 1. for every image in 'folderpath', a .tif image with the accumulator
%    space will be saved in the folder, with '_AccSpace' added to the name
% 2. a table with resuls will be saved in Results.csv;
%    Columns are: name of file, radial symmetry likelihood, row of global maximum,
%    column of global maximum
%
% Marcelo Cicconet, 2016 Jun 14

folderpath = uigetdir;

nc = 3;
str = cell(1,nc);
for i = 1:nc
    str{i} = sprintf('%d',i);
end
s = listdlg('PromptString','Select a channel:',...
            'SelectionMode','single',...
            'ListString',str);
if isempty(s)
    error('no channel selected')
    return
end
channel = s;

listing = dir(folderpath);
h = waitbar(0,'Computing...');

names = {};
rsls = [];
rowcenters = [];
colcenters = [];
for j = 1:size(listing,1)
    waitbar((j-1)/size(listing,1))
    name = listing(j).name;
    isdir = listing(j).isdir;
    if ~isdir
        % does not process _AccSpace images and Resuls.txt
        if ~isempty(strfind(name,'_AccSpace')) || ~isempty(strfind(name,'_ViewOutput')) || strcmp(name,'Results.csv') || name(1) == '.'
            continue
        end
        
        filepath = [folderpath filesep name];
        
        ImageData = bfopen(filepath);

        if channel > size(ImageData{1},1)
            close(h)
            error('channel %d does not exist for image\n%s\n',channel,filepath)
            return
        end
        
        I = ImageData{1}{channel};
        I = double(I)/255;

        [A,lik,locmax] = radialSymmetryLikelihood(I,0);

        [pathstr,name,~] = fileparts(filepath);
        % imwrite(A,[pathstr filesep name '_AccSpace.tif'])
        writeFloatImageToTiffFile(single(A),[pathstr filesep name '_AccSpace.tif']);
        
        names = {names{:} name};
        rsls = [rsls lik];
        rowcenters = [rowcenters locmax(1)];
        colcenters = [colcenters locmax(2)];
        
        A(locmax(1),locmax(2)) = 0;
        for a = 0:pi/4:2*pi-pi/4;
            d = 0;
            p = round(locmax+d*[cos(a); sin(a)]);
            while p(1) >= 1 && p(1) <= size(I,1) && p(2) >= 1 && p(2) <= size(I,1)
                I(p(1),p(2)) = 1;
                d = d+5;
                p = round(locmax+d*[cos(a); sin(a)]);
            end
        end
        imwrite([I A],[pathstr filesep name '_ViewOutput.png']);
    end
end
close(h)

rsl = rsls';
row = rowcenters';
col = colcenters';
name = names';
for i = 1:length(names) % 'writetable' doesn't handle well commas in names
    name(i) = strrep(name(i),',','_');
end
T = table(name,rsl,row,col);
writetable(T,[folderpath filesep 'Results.csv']);
disp(T)