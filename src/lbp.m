function result = lbp(im)
    % If there are multiple planes, do it for all
    result = im;
    for plane = 1:size(im,3)
        result(:,:,plane) = colfilt(im(:,:,plane),[3 3],'sliding',@getLBP);
    end
    
    function output = getLBP(im)
        output = zeros(1,size(im,2));
        for col=1:size(im,2)
            temp = im(:,col);
            I = reshape(temp, [3 3]);
            data = double(I); %use pixel data
            % reduce center pixel value from the entire block
            data = data - data(2,2);
        
            % threshold data
            data(data>=0) = 1;
            data(data<0) = 0;
            
            % build kernel of powers of two, clockwise
            kernel =double([1 2 4;8 0 16;32 64 128]);
            output(1,col) = sum(sum(data .* kernel));
        end