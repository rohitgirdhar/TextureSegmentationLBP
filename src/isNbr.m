function ans = isNbr(r1,r2)
ans = 0;

xmn1 = min(r1(:,1));
ymn1 = min(r1(:,2));
xmn2 = min(r2(:,1));
ymn2 = min(r2(:,2));

xmx1 = max(r1(:,1)+r1(:,3)-1);
ymx1 = max(r1(:,2)+r1(:,3)-1);
xmx2 = max(r2(:,1)+r2(:,3)-1);
ymx2 = max(r2(:,2)+r2(:,3)-1);

xmn = min(xmn1, xmn2);
ymn = min(ymn1, ymn2);
xmx = max(xmx1, xmx2);
ymx = max(ymx1, ymx2);
% top = xmin, bottom = xmax, right = ymax, left = ymin
h1 = ymx1-ymn1;
h2 = ymx2-ymn2;
v1 = xmx1-xmn1;
v2 = xmx2-xmn2;
h = ymx-ymn;
v = xmx-xmn;
intersection=0;
if((h1+h2 == h & v1+v2 < v) | (h1+h2 < h & v1+v2 == v)) 
    intersection = 1;
end
%intersection = ((ymn2>ymx1) & (ymx2<ymn1) & (xmn2>xmx1) & (xmx2<xmn1)));
if(intersection == 1)
    ans = 1;
end
if(intersection == 0)
    
    xmn = min(xmn1, xmn2);
    ymn = min(ymn1, ymn2);
    xmx = max(xmx1, xmx2);
    ymx = max(ymx1, ymx2);
    im = zeros(xmx-xmn+1, ymx-ymn+1);
    for i=1:size(r1,1)
        x = r1(i,1);
        y = r1(i,2);
        w = r1(i,3);
        im(x-xmn+1:x+w-1-xmn+1,y-ymn+1:y+w-1-ymn+1)=1;
    end
    for i=1:size(r2,1)
        x = r2(i,1);
        y = r2(i,2);
        w = r2(i,3);
        im(x-xmn+1:x+w-1-xmn+1,y-ymn+1:y+w-1-ymn+1)=2;
    end
    ans=0;
    
    for i=1:size(im,1)
        for j=1:size(im,2)
            if(im(i,j) == 0)
                continue;
            end
            if(i>1 & im(i,j)+im(i-1,j)==3)
                ans=1;
            end
            if(j>1 & im(i,j)+im(i,j-1)==3)
                ans=1;
            end
            if(ans==1)
                break;
            end
        end
        
        if(ans==1)
            break;
        end
    end
end
