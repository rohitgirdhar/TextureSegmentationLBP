function [S, R] = runIt(I)
    tic;
    R = hSplit(I);
    T = aggMerge(R);
    S = colorSegments(T,size(I,1),size(I,2));
    figure;
    subplot(1,2,1), subimage(I);
    subplot(1,2,2), subimage(S, colormap('lines'));
    toc;