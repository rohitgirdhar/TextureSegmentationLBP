function R = isNbr(r1,r2)
R = 0;
b1 = r1;
b2 = r2;

xmn1 = b1(1);
ymn1 = b1(2);
xmx1 = b1(1)+b1(3)-1;
ymx1 = b1(2)+b1(3)-1;
xmn2 = b2(1);
ymn2 = b2(2);
xmx2 = b2(1)+b2(3)-1;
ymx2 = b2(2)+b2(3)-1;
xmn = min(xmn1, xmn2);
ymn = min(ymn1, ymn2);
xmx = max(xmx1, xmx2);
ymx = max(ymx1, ymx2);
h1 = ymx1-ymn1+1;
h2 = ymx2-ymn2+1;
v1 = xmx1-xmn1+1;
v2 = xmx2-xmn2+1;
h = ymx-ymn+1;
v = xmx-xmn+1;

if ((h1+h2 > h && v1+v2 == v) || (v1+v2 > v && h1+h2 == h))
    R=1;
end