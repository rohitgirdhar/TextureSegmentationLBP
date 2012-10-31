function I = colorSegments(R, M, N)
    % Returns a color image as per segments in R
    labels = R.keys;
    I = zeros(M,N);
    cur_lab = 0;
    for i=1:length(labels)
        cur_lab = cur_lab + 1;
        blocks = R(labels{i}).blocks;
        for j=1:size(blocks,1)
            I(blocks(j,1):blocks(j,1)+blocks(j,3)-1, blocks(j,2):blocks(j,2)+blocks(j,3)-1) = cur_lab;
        end
    end
    