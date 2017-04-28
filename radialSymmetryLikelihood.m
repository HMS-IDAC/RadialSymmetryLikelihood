function [A,lik,locmax,tandata] = radialSymmetryLikelihood(I,displayprogress)
    % coefficient of radial symmetry, i.e., amount of radial symmetry
    %     present in the image
    % ----------
    % INPUTS
    % expects double, range [0,1], grayscale image input I
    % set displayprogress = 1 to display progress bar, 0 otherwise
    % ----------
    % OUTPUTS
    % lik: radial symmery coefficient, ranges from 0 (low symmetry)
    %    to 1 (high symmetry)
    % A: accumulagor space, range [0,1]; lik is the mean value of A
    % locmax: location (row, col) of maximum in A
    % tandata (optional):
    %     tangent data for quiver plot
    %     example: quiver(tandata(1,:),tandata(2,:),tandata(3,:),tandata(4,:),'y.')
    % ----------
    % EXAMPLE
    % I = imread('Image.png');
    % I = double(I)/255;
    % [A,lik,locmax] = radialSymmetryLikelihood(I,1);
    %
    % Marcelo Cicconet, 2016 Jun 14

    msi = max(size(I));
    
    nangs = 32; % number of angles (equally distributed in [0,pi))
    stretch = 1; % stretch of morlet wavelet
    scale = round(msi/256); % scale of morlet wavelet
    hopsize = round(msi/100); % distance between centers of windows
    halfwindowsize = floor((hopsize-2)/2); % half width of window
    magthreshold = 0.01; % magnitude threshold for wavelet consideration
    convtype = 'real';

    I = adapthisteq(I);
    [m,a,x,y] = coefficientslist(I,'NumAngles',nangs,'WavStretch',stretch,'WavScale',scale,'WavNumPeaks',1, ...
                                 'HopSize',hopsize,'HalfWindowSize',halfwindowsize,'MagThreshold',magthreshold,'ConvType',convtype);
    
%     J = waveletinimage(I,stretch,scale);
%     imshow(J), pause
%     J = drawoutputslist(I,x,y,m,a,hopsize,2,1,0);
%     imshow(J), pause

    A = acc(size(I,1),size(I,2),x,y,m,a,displayprogress);

    sigma = round(msi/32);
    K = fspecial('gaussian',3*[sigma sigma],sigma);
    A = conv2(A,K,'same');

    A = A/max(max(A));
    lik = 1-sum(sum(A))/numel(A);

    [row, col] = find(A == 1);
    locmax = [row; col];
    
    tandata = [y; x; sin(a); cos(a)];
end