function result = computeC(im)
    % For multiple planes, do separate for all
    result = zeros(size(im));
    for plane = 1:size(im,3)
        result(:,:,plane) = colfilt(im(:,:,plane),[3 3],'sliding',@getC);
    end
    
    function output = getC(im)
        output = zeros(1,size(im,2));
        for col=1:size(im,2)
            temp = im(:,col);
            I = reshape(temp, [3 3]);
            data = double(I); %use pixel data
            % reduce center pixel value from the entire block
            th = data - data(2,2);
        
            % threshold data
            th(th>=0) = 1;
            th(th<0) = 0;
            
            th(2,2) = 0; % As in the paper

            % For the 1s in the kernel
            av1 = 0;
            s = sum(th(:));
            if(s > 0)
                av1 = sum(sum( data .* th )) / s;
            end
            
            % For the 0s in the kernel
            th = th(:,:) - 1;
            th = -th;
            th(2,2) = 0;
            av2 = 0;
            s = sum(th(:));
            if(s > 0)
                av2 = sum(sum(data .* th)) / s;
            end
            output(1, col) = max(0,av1 - av2);
        end