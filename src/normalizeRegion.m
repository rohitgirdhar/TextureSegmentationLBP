function I = normalizeRegion(I, R)
    % Takes an image and returns the image with its region numbers changed
    % to 1,2,3...
    
    labs = R.keys;
    num = 1;
    for i=1:length(labs)
        I(I==labs{i}) = num;
        num = num + 1;
    end
    
    
    