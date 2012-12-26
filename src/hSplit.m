function regions = hSplit(I, X)
    % Temporary for now, just construct the regions map
    temp = struct('blocks', [0 0 0], 'hist', zeros(10));
    regions = containers.Map(uint32(1), temp); % KeyType is uint32.
    remove(regions,1);
    if(size(I,3) ~= 1)
        I = rgb2gray(I);
    end
    L = lbp(I);
    C = computeC(I);
    nr = 0; % The current region number to use
    step = 64;
    
    for i=1:step:size(I,1)
        for j=1:step:size(I,2)
             [regions, nr] = tryDivide(i, j, step, regions, nr, L, C, X);
        end
    end
    disp('hSplit Done');
    
    function [regions, nr] = tryDivide(r, c, sz, regions, nr, L, C, X)
        
        % X = 1.7; % Threshold to stop divide % taking as input
        S_min = 8;
        
        if(sz <= S_min)
            H = computeHist(L(r:r+sz-1, c:c+sz-1), C(r:r+sz-1, c:c+sz-1), 8);
            S = struct('blocks', [r,c,sz], 'hist', H);
            nr = nr+1;
            regions(nr) = S;
            return;
        end
        H1 = computeHist(L(r:r+sz/2-1, c:c+sz/2-1), C(r:r+sz/2-1, c:c+sz/2-1), 8);
        H2 = computeHist(L(r+sz/2:r+sz-1, c:c+sz/2-1), C(r+sz/2:r+sz-1, c:c+sz/2-1), 8);
        H3 = computeHist(L(r:r+sz/2-1, c+sz/2:c+sz-1), C(r:r+sz/2-1, c+sz/2:c+sz-1), 8);
        H4 = computeHist(L(r+sz/2:r+sz-1, c+sz/2:c+sz-1), C(r+sz/2:r+sz-1, c+sz/2:c+sz-1), 8);
        
        G1 = computeG(H1, H2);
        G2 = computeG(H1, H3);
        G3 = computeG(H1, H4);
        G4 = computeG(H2, H3);
        G5 = computeG(H2, H4);
        G6 = computeG(H3, H4);
        
        Gs = [G1 G2 G3 G4 G5 G6];
        if(max(Gs) / min(Gs) > X)
            % Now divide further
            [regions, nr] = tryDivide(r, c, sz/2, regions, nr, L, C, X);
            [regions, nr] = tryDivide(r+sz/2, c, sz/2, regions, nr, L, C, X);
            [regions, nr] = tryDivide(r, c+sz/2, sz/2, regions, nr, L, C, X);
            [regions, nr] = tryDivide(r+sz/2, c+sz/2, sz/2, regions, nr, L, C, X);
        else
            H = computeHist(L(r:r+sz-1, c:c+sz-1), C(r:r+sz-1, c:c+sz-1), 8);
            S = struct('blocks', [r,c,sz], 'hist', H);
            nr = nr+1;
            regions(nr) = S;
        end
        