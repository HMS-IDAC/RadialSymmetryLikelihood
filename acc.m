function A = acc(nr,nc,x,y,m,a,displayprogress)
    s = length(m);
    A = zeros(nr,nc);
    
    if displayprogress
        h = waitbar(0,'Computing...');
    end
    for j = 1:s
        if displayprogress
            waitbar((j-1)/s)
        end
        
        p0 = [x(j); y(j)];
        v = [cos(a(j)); sin(a(j))];
        d = 0;
        p = round(p0+d*v);
        while p(1) >= 1 && p(1) <= nr && p(2) >= 1 && p(2) <= nc
            A(p(1),p(2)) = A(p(1),p(2))+1;
            d = d+1;
            p = round(p0+d*v);
        end
        d = -1;
        p = round(p0+d*v);
        while p(1) >= 1 && p(1) <= nr && p(2) >= 1 && p(2) <= nc
            A(p(1),p(2)) = A(p(1),p(2))+1;
            d = d-1;
            p = round(p0+d*v);
        end
    end
    if displayprogress
        close(h)
    end
end