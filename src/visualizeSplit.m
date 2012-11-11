function visualizeSplit(I, R)
    figure;
    imshow(I);
    labs = R.keys();
    for i=1:length(labs)
        r = R(labs{i});
        rectangle('Position', [r.blocks(1), r.blocks(2), r.blocks(3), r.blocks(3)]  ,'LineWidth',2, 'EdgeColor','b');
    end