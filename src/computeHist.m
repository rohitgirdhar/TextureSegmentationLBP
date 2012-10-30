function H = computeHist(lbp_img, c_img, nbins)
    % Inputs:
    % lbp_img: A subimage with LBP values of pixels
    % c_img: A subimage with contrast (C) values of pixels
    % nbins: no. of bins in result
    % Ouput:
    % H = 256xnbins histogram of the given sub-image
    
    H = zeros(256, nbins);
    if(size(lbp_img,3) ~= 1 || size(c_img,3) ~= 1 || size(lbp_img,1) ~= size(c_img,1) || size(lbp_img,2) ~= size(c_img,2))
        exception = MException('VerifyInput: size of C and LBP not same or invalid');
        throw(exception);
    end
    
    % To handle 0s
    lbp_img(:,:) = lbp_img(:,:) + 1;
    c_img(:,:) = c_img(:,:) + 1;
    
    % C will always be greater than 0 and less than 256
    fac = 256/nbins;
    
    for i=1:size(lbp_img,1)
        for j=1:size(lbp_img, 2)
            bin = ceil(c_img(i,j)/fac);
            try
                H(lbp_img(i,j), bin) = H(lbp_img(i,j), bin) + 1;
            catch err
                disp(err);
            end
        end
    end