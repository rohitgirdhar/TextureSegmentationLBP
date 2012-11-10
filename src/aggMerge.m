function regions = aggMerge(regions)
    % Agglomerative Merges regions
    % regions: a map with key as region label, and points to a struct with
    % 2 values: blocks
    MI_max = 0;
    Y = 2.0;
    
    nregions = regions.length;
    labels = regions.keys;
    lim = 0.1*nregions;
    cnt = 0;
    
    parent = zeros(1,nregions);
    for i=1:nregions
        parent(i) = i;
    end
    
    nbrs = containers.Map(uint32(1), [1 0]); % KeyType is uint32.
    remove(nbrs,1);
    
    for i=1:nregions
        for j=i+1:nregions
            if(isNbr(regions(labels{i}).blocks, regions(labels{j}).blocks))
                if(isKey(nbrs, labels{i}))
                    nbrs(labels{i}) = [nbrs(labels{i}) labels{j}];
                else
                    nbrs(labels{i}) = [labels{j}];
                end
                
                if(isKey(nbrs, labels{j}))
                    nbrs(labels{j}) = [nbrs(labels{j}) labels{i}];
                else
                    nbrs(labels{j}) = [labels{i}];
                end
            end
        end
    end
    
    disp('aggMerge: Created nbr list');
    
    len_chain = ones(1,nregions);
    
    while(regions.length > 1)
        %disp('Now number regions');
        %disp(regions.length);
        [r1, r2, MI, parent] = getLeastMI(regions, nbrs, parent);
        
        % r1 and r2 are the parents of the regions to be merged
        if(len_chain(r1) < len_chain(r2))
            temp = r1;
            r1 = r2;
            r2 = temp;
        end
   
        [r2 parent] = getParent(r2,parent);
        [r1 parent] = getParent(r1,parent);
        
        T1 = regions(r1);
        T2 = regions(r2);
        T1.blocks = [T1.blocks; T2.blocks];
        T1.hist = T1.hist + T2.hist;
        parent(r2) = r1;
        
        N2 = nbrs(r2);
        N1 = nbrs(r1);
        Nf = zeros(length(N1)+length(N2));
        n_i = 1;
        for i=1:length(N2)
            [temp parent] = getParent(N2(i), parent);
            if(temp ~= r1)
                Nf(n_i) = temp;
                n_i = n_i+1;
            end
        end
        
        for i=1:length(N1)
            [temp parent] = getParent(N1(i), parent);
            Nf(n_i) = temp;
            n_i = n_i+1;
        end
        Nf = Nf(1:n_i-1);
        Nf = unique(Nf);
        
        len_chain(r1) = len_chain(r1) + len_chain(r2);
        regions(r1) = T1;
        nbrs(r1) = Nf;
        regions.remove(r2);
        nbrs.remove(r2);
        cnt = cnt + 1;
        if(cnt > lim && MI/MI_max > Y)
            break;
        end
        MI_max = max(MI, MI_max);
    end
    disp('aggMerge Done');
    
    function [P, parent] = getParent(r, parent)
        if(parent(r) == r)
            P = r;
            return;
        else
            [temp, parent] = getParent(parent(r), parent);
            P = temp;
            parent(r) = temp;
            return;
        end
    
    function [r1, r2, minMI parent] = getLeastMI(regions, nbrs, parent)
        labels = regions.keys;
        minMI = inf;
        r1 = labels{1};
        r2 = labels{2};
        for i=1:size(labels,2)
            [temp parent] = getParent(nbrs(labels{i}), parent);
            for j=1:length(temp)
                if(temp(j) == labels{i})
                    continue;
                end
                MI = getMI(regions, labels{i}, temp(j));
                if(MI < minMI)
                    minMI = MI;
                    r1 = labels{i};
                    r2 = temp(j);
                end
                
            end
        end
        
    function MI = getMI(regions, i, j)
        p = min(getSize(regions(i).blocks), getSize(regions(j).blocks));
        G = computeG(regions(i).hist, regions(j).hist);
        MI = p*G;
        
        function sz = getSize(blocks)
            temp = blocks(:,3);
            sz = sum(temp .* temp);
            
