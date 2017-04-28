% computes radialSymmetryLikelihood on a single image file
% outputs:
% 1. a .tif image of the accumulator space will be saved
%    in the same folder of the input, with '_AccSpace' added to the name
% 2. two values will be displayed on Matlab's prompt (command line):
%    > radial symmery likelihood
%    > row and column of global maximum of the accumulator space
%
% Marcelo Cicconet, 2016 Jun 14

[filename, pathname] = uigetfile('*');
filepath = [pathname filename];

ImageData = bfopen(filepath);

nc = size(ImageData{1},1);
channel = 1;
if nc > 1
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
end

I = ImageData{1}{channel};
I = double(I)/255;

displayprogress = 0; % set to 1 to display progress bar
[A,lik,locmax,tandata] = radialSymmetryLikelihood(I,displayprogress);

[pathstr,name,~] = fileparts(filepath);
% imwrite(A,[pathstr filesep name '_AccSpace.tif'])
writeFloatImageToTiffFile(single(A),[pathstr filesep name '_AccSpace.tif']);

fprintf('Radial Symmetry Likelihood:\n%f\n',lik)
fprintf('Row, Column location of global maximum:\n%d\t%d\n',locmax(1),locmax(2))

figure(1)
imshow(I), hold on
quiver(tandata(1,:),tandata(2,:),tandata(3,:),tandata(4,:),'y.'), hold off

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

figure(2)
imshow([I A])
imwrite([I A],[pathstr filesep name '_ViewOutput.png']);
figure(2)
title(sprintf('Radial Symmetry Likelihood: %.02f', lik));