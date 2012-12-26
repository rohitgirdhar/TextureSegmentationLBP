function I = pixelwise(I,Or,H, max_sweeps)
newI=I;
% Inputs :
% I : Labelled image.. 1,2,3,...n regions
% Or : Original gray scale image
% H : Hash table with region number as the key and value being a structure (hist and blocks as the elements)
neigh = [];
L = lbp(Or);
C = computeC(Or);
r = 16; % square size = 2*r + 1
for i=1:size(I,1)
    for j=1:size(I,2)
        neigh = [neigh; [i, j]];
    end
end
total_sweeps=0;
neigh = unique(neigh, 'rows');
while (size(neigh,1) > 0 && total_sweeps < max_sweeps)
    total_sweeps = total_sweeps + 1;
    new_neigh=[];
    for k=1:size(neigh,1)
        i=neigh(k,1);
        j=neigh(k,2);
        if border(i,j,r,I) == 1
            % considering only the border pixels and those which can be a center of a (2*r+1)*(2*r+1) square
            hist = computeHist(L(i-r:i+r,j-r:j+r), C(i-r:i+r,j-r:j+r), 8); % Hist of a (2*r+1)X(2*r+1) square centered at (i,j)
            G1=computeG(hist,H(I(i-1,j)).hist);
            G2=computeG(hist,H(I(i+1,j)).hist);
            G3=computeG(hist,H(I(i,j-1)).hist);
            G4=computeG(hist,H(I(i,j+1)).hist);
            minG = min([G1,G2,G3,G4]);
            if minG==G1
                new_label = I(i-1,j);
            end
            if minG==G2
                new_label = I(i+1,j);
            end
            if minG==G3
                new_label = I(i,j-1);
            end
            if minG==G4
                new_label = I(i,j+1);
            end
            if new_label ~= I(i,j)
                hist = computeHist(L(i,j),C(i,j),8);
                h1 = H(I(i,j)).hist-hist;
                h2 = H(new_label).hist+hist;
                H(I(i,j)) = struct('blocks', H(I(i,j)).blocks, 'hist', h1);
                H(new_label) = struct('blocks', H(new_label).blocks, 'hist', h2);
                if I(i-1,j) ~= I(i,j)
                    new_neigh = [new_neigh; [i-1, j]];
                end
                if I(i+1,j) ~= I(i,j)
                    new_neigh = [new_neigh; [i+1, j]];
                end
                if I(i,j-1) ~= I(i,j)
                    new_neigh = [new_neigh; [i, j-1]];
                end
                if I(i,j+1) ~= I(i,j)
                    new_neigh = [new_neigh; [i, j+1]];
                end
                newI(i,j) = new_label;
            else
                newI(i,j) = I(i,j);
            end
            
            % else no rebelling.! :)
        end
    end
    neigh=unique(new_neigh, 'rows');
    
    I = newI;
end


function val = border(i,j,r,I)
val=0;
flag=0;
if ((i-r)>=1 && (i+r)<=size(I,1) && (j-r)>=1  && (j+r)<=size(I,2))
    flag=1;
end
if (flag & (I(i-1,j)~=I(i,j) | I(i+1,j) ~= I(i,j) | I(i,j-1) ~= I(i,j) |  I(i,j+1) ~= I(i,j)))
    val=1;
end
