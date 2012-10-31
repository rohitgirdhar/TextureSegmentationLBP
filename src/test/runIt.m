function runIt(I)
    R = hSplit(I);
    T = aggMerge(R);
    S = colorSegments(T,256,256);
    figure;
    subplot(1,2,1), subimage(I);
    subplot(1,2,2), subimage(S, colormap('lines'));