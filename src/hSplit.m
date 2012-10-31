function regions = hSplit(I)
    % Temporary for now, just construct the regions map
    temp = struct('blocks', [0 0 0], 'hist', zeros(10));
    regions = containers.Map(uint32(1), temp); % KeyType is uint32.
    remove(regions,1);
    if(size(I,3) ~= 1)
        I = rgb2gray(I);
    end
    L = lbp(I);
    C = computeC(I);
    step = 64;
    nr = 0;
    for i=1:step:size(I,1)
        for j=1:step:size(I,2)
            H = computeHist(L(i:i+step-1, j:j+step-1), C(i:i+step-1, j:j+step-1), 8);
            S = struct('blocks', [i,j,step], 'hist', H);
            nr = nr+1;
            regions(nr) = S;
        end
    end
    disp('hSplit Done');