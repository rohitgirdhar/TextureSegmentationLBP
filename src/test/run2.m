function run2(dname, res_dname)
    % Takes a directory dname, runs the detector on all images in the it,
    % naming convention as in Prague mosaic dataset
    % stores results in res_dname
    
    num_test = 20; % tell the number of test images
    if(~isdir(res_dname))
            mkdir(res_dname);
    end
    for testImage=1:num_test
        fname = strcat('tm', num2str(testImage), '_1_1.png');
        fname = fullfile(dname, fname)
        I = imread(fname);
        if(size(I,3) ~= 1)
            I = rgb2gray(I);
        end
        sz = size(I);
        I = imresize(I, [256 256]);
        
        [S R Q] = runIt(I);
        Q = imresize(Q, sz, 'nearest');
        
        resname = strcat('seg', num2str(testImage), '_1_1.png');    
        resname = fullfile(res_dname, resname);
        Q = uint8(Q);
        imwrite(Q, resname, 'png')
    end
    