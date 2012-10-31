function regions = aggMerge(regions)
    % Agglomerative Merges regions
    % regions: a map with key as region label, and points to a struct with
    % 2 values: blocks
    MI_max = 0;
    Y = 2.0;
    nregions = regions.length;
    lim = 0.1*nregions;
    cnt = 0;
    while(regions.length > 1)
        [r1, r2, MI] = getLeastMI(regions)
        T1 = regions(r1);
        T2 = regions(r2);
        T1.blocks = [T1.blocks; T2.blocks];
        T1.hist = T1.hist + T2.hist;
        regions(r1) = T1;
        regions.remove(r2);
        cnt = cnt + 1;
        if(cnt > lim && MI/MI_max > Y)
            break;
        end
        MI_max = max(MI, MI_max);
    end
    
    function [r1, r2, minMI] = getLeastMI(regions)
        labels = regions.keys;
        minMI = inf;
        r1 = labels{1};
        r2 = labels{2};
        for i=1:size(labels,2)
            for j=i+1:size(labels,2)
                if(isNbr(regions(labels{i}).blocks, regions(labels{j}).blocks))
                    MI = getMI(regions, labels{i}, labels{j});
                    if(MI < minMI) 
                        minMI = MI;
                        r1 = labels{i};
                        r2 = labels{j};
                    end
                end
            end
        end
        
    function MI = getMI(regions, i, j)
        p = min(getSize(regions(i).blocks), getSize(regions(j).blocks));
        G = computeG(regions(i).hist, regions(j).hist);
        MI = p*G
        
        function sz = getSize(blocks)
            temp = blocks(:,3);
            sz = sum(temp .* temp);
