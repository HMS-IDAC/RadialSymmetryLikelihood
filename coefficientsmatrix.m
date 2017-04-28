function [M,A,X,Y] = coefficientsmatrix(I,nangs,stretch,scale,npeaks,hopsize,halfwindowsize,magthreshold,convtype,padtype)
% I should be double, and in the range [0,1]

if ~strcmp(convtype,'imag')
    orientations = (0:nangs-1)*180/nangs;
else
    orientations = (0:nangs-1)*360/nangs;
end
norientations = length(orientations);

windowsize = 2*halfwindowsize;

nr = min([floor((size(I,1)-windowsize)/hopsize)+1 size(I,1)]);
nc = min([floor((size(I,2)-windowsize)/hopsize)+1 size(I,2)]);

C = zeros(nr,nc);
A = zeros(nr,nc);
X = zeros(nr,nc);
Y = zeros(nr,nc);

RI3 = zeros(size(I,1),size(I,2),norientations);

[mr,~] = smorlet(stretch,scale,0,npeaks);
PI = padarray(I,(size(mr)-1)/2,padtype);
for j = 1:norientations
    orientation = orientations(j);

    [mr,mi] = smorlet(stretch,scale,orientation,npeaks);
    
    if strcmp(convtype,'real')
        RI3(:,:,j) = conv2(PI,mr,'valid');
    elseif strcmp(convtype,'real+')
        R = conv2(PI,mr,'valid');
        RI3(:,:,j) = R.*(R > 0);
    elseif strcmp(convtype,'imag')
        RI3(:,:,j) = conv2(PI,mi,'valid');
    elseif strcmp(convtype,'complex')
        R = conv2(PI,mr,'valid');
        Z = conv2(PI,mi,'valid');
        RI3(:,:,j) = sqrt(R.*R+Z.*Z);
    end
end

rows = round(linspace(halfwindowsize+1,size(I,1)-halfwindowsize,nr));
cols = round(linspace(halfwindowsize+1,size(I,2)-halfwindowsize,nc));

for k = 1:nr
    for l = 1:nc
        row = rows(k);
        col = cols(l);
        M3 = RI3(row-halfwindowsize:row+halfwindowsize,col-halfwindowsize:col+halfwindowsize,:);
        [M,IM] = max(M3,[],3);
        [mC,imC] = max(M);
        [mR,imR] = max(mC);
        C(k,l) = mR;
        rm = imC(imR);
        cm = imR;
        if ~strcmp(convtype,'imag')
            A(k,l) = (IM(rm,cm)-1)*pi/nangs+pi/2;
        else
            A(k,l) = (IM(rm,cm)-1)*2*pi/nangs+pi/2;
        end
        X(k,l) = row+rm-(halfwindowsize+1);
        Y(k,l) = col+cm-(halfwindowsize+1);
    end
end

M = zeros(size(C));
t = magthreshold*max(max(C));
for k = 2:nr-1
    for l = 2:nc-1
        bM = C(k-1:k+1,l-1:l+1);
        if C(k,l) > 0.75*max(max(bM)) && min(min(bM)) > t
            M(k,l) = C(k,l);
        end
    end
end

end