function G = computeG2(hist1, hist2)
% hist1 and hist2 are 2 256x(nbins) histograms
% Returns G-statistic for the 2 histogram
G = 0;

hist1(hist1==0) = 1;
hist2(hist2==0) = 1;

if(size(hist1,2) == size(hist2,2))
    B1 = sum(hist1); % bins 1
    B2 = sum(hist2); % bins 2
    S1 = sum(B1); % sum 1
    S2 = sum(B2); % sum 2
    A = (sum(sum(hist1.*log(hist1)))+sum(sum((hist2.*log(hist2)))));
    B = -(S1*log(S1) + S2*log(S2));
    C = -(sum(sum((hist1+hist2).*log(hist1+hist2))));
    D = ((S1+S2)*log(S1+S2));
    G = 2*(A + B + C + D);
end