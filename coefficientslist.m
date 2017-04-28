function [m,a,x,y] = coefficientslist(I,varargin)

% list of wavelet coefficients (magnitudes, angles, locations)
% ----------
% INPUTS
% expects double, range [0,1], grayscale image input I
% varargin:
%   'NumAngles', default 32: number of angles considered in [0,pi) or
%       [0,2*pi) (depending on 'ConvType')
%   'WavStretch', default 0: stretch of wavelets
%   'WavScale', default 1: scale of wavelets
%   'WavNumPeaks', default 1: number of 'visible' peaks in wavelets
%   'HopSize', default 3: one coefficient is output per 'HopSize' pixels
%   'HalfWindowSize', default 1: half size of window around which best
%       coefficient is looked for; should be no larger than (HopSize-1)/2
%   'MagThreshold', default 0.01: threshold coefficient should pass to be
%       considered
%   'ConvType', default 'complex': type of wavelet used in convolution
%       'complex' -- good for 'ridges' and 'step' type edges
%       'real' -- good for ridge-type edges
%       'imag' -- good for step-type edges
%       'real+' -- better than 'real' in some cases
%   'PadType', default 'replicate': type of image padding used by padarray
%       function for convolution; see padarray help for options
% ----------
% OUTPUTS
% m: magnitudes, in range [0,1]
% a: angles, in radians
% x: row location of coefficient (Yeah I know, this is different from Matlab's
%   coordinate system. Sorry.)
% y: column location of coefficients
% ----------
% EXAMPLE
% see RunMe.m at this function's directory
%
% Marcelo Cicconet, 2016 Aug 24

ip = inputParser;
ip.addParameter('NumAngles',32);
ip.addParameter('WavStretch',0);
ip.addParameter('WavScale',1);
ip.addParameter('WavNumPeaks',1);
ip.addParameter('HopSize',3);
ip.addParameter('HalfWindowSize',1);
ip.addParameter('MagThreshold',0.01);
ip.addParameter('ConvType','complex');
ip.addParameter('PadType','replicate');

ip.parse(varargin{:});
p = ip.Results;

[M,A,X,Y] = coefficientsmatrix(I,p.NumAngles,p.WavStretch,p.WavScale,p.WavNumPeaks,p.HopSize,p.HalfWindowSize,p.MagThreshold,p.ConvType,p.PadType);
s = sum(sum(M > 0));
m = zeros(1,s);
a = zeros(1,s);
x = zeros(1,s);
y = zeros(1,s);
[nr,nc] = size(M);
index = 0;
for i = 1:nr
    for j = 1:nc
        if M(i,j) > 0
            index = index+1;
            m(index) = M(i,j);
            a(index) = A(i,j);
            x(index) = X(i,j);
            y(index) = Y(i,j);
        end
    end
end

end
