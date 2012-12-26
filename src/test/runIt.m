function [S, R, Q] = runIt(I)
    tic;
    R = hSplit(I, 1.4);
    T = aggMerge(R, 1.6);
    S = colorSegments(T,size(I,1),size(I,2));
    Q = pixelwise(S, I, R, 100);
    Q = normalizeRegion(Q, R);
    %figure;
    %subplot(1,2,1), subimage(I);
    %subplot(1,2,2), subimage(Q, colormap('lines'));
    toc;