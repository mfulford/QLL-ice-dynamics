function [LayerCross, LayerPopulation, lifetime, cross_id] = ...
    coord_layerCross(tcheckrange, min_not_max, coord, layer_pos, layer_pos_OTHER, middle_dat, nboundary, nregion, layer_deep, bound_id)

% Calculate rate of diffusion across layer boundaries
% Boundary positions imported into function. Calculate rate from frequency
% of molecule coordinates crossing the boundaries. Ignore crossings which
% return within a set timescale so as not to take into account vibrating
% molecules at the boundaries.
% From histogram determine top nboundary/2 and bottom nboundary/2
% Then define based on these boundaries, nregion regions as follows
% (eg if nboundary = 14 and nregion = nboundary+1 = 15)
% top surface r1 | r2 | r3 | r4 | r5 | r6 | r7 | r8 ...bulk... r8 | r9 | r10 | r11 |
% r12 | r13 | r14 | r15 bottom surface
%
% Boundary are numbered based on number of region to the left
% Determine how many times each boundary are crossed in each direction
% a=1 is crossing towards bulk
% a=2 is crossing towards surface
%
% Crossing is only counted if the molecule does not return to the initial
% layer for at least tcheckrange steps. NOTE only monitor if it returns to
% initial layer in time frame, therefore if it crosses further then cross
% is successful. (eg region 3 -->4 --> 5 )

cross_id(1,:) =[0, 0];

%% Initialise Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[tot_time num_atoms] = size(coord);
count =0;
half = (nboundary/2);

LayerPopulation = zeros(nregion,1);
for i=1:nboundary
    LayerCross{1}(i) = 0; LayerCross{2}(i) = 0;
end
A=1; B=2;

%convertion factor to convert frequency to number of crossings per ns
convns = 200/(tot_time-tcheckrange);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Initialise lcheck vector %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lcheck is vector of integers correspond to all boundaries except boundary half+1
% boundary half+1 (middle) will be dealt with seperately in code
for i=1:nboundary
    if i == half+1
        continue;
    else
        count = count+1;
        lcheck(count) = i;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Begin Main Loop %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loop over atoms, then loop over time

count_1 =0; count_2=0;
countCross = 0;
count_r1 = 0; count_r2 = 0; count_r3 = 0;
for i=1:num_atoms
    cycle_run = false;
    %     Determine initial position/region of molecule
    p = coord(1,i);
    
    % to increase speed ignore any atoms which are deep in bulk
    if (p > layer_deep(1)) && (p <= layer_deep(2))
        % molecule is deep within bulk. Ignore
        continue;
    elseif (p > layer_pos(half)) && (p <= layer_pos(half+1)) % if in middle region
        pos_prev = half+1;
    elseif p > layer_pos(nboundary) % if on "top" surface
        pos_prev = nregion;
    else
        if (min_not_max == true) % if doing minima / troughs
            for l=lcheck % check if in any lcheck regions
                if p <= layer_pos(l)
                    pos_prev = l;
                    break;
                end
            end
        elseif (min_not_max == false) % if doing maxima /peaks
            cycle_run = true;
            for l=lcheck
                if ((l==1) && (p <=layer_pos(l))) % if on bottom surface
                    pos_prev = l;
                    cycle_run = false;
                    break;
                elseif (p <= layer_pos(half)) && (p <= layer_pos(l)) && (p > layer_pos_OTHER(l-1)) % if in bottom half  l <= half
                    pos_prev = l;
                    cycle_run = false;
                    break;
                elseif (p > layer_pos(half+1)) && (p >= layer_pos(l)) && (p < layer_pos_OTHER(l+1)) % if in top half l > half
                    pos_prev = l;
                    cycle_run = false;
                    break
                end
            end
        end
    end
    
    if (min_not_max == false) && (cycle_run == true) % cycle/continue if molecule not in correct "semi-layer"
        continue
    end
    
    %     loop over time 2 to end-tcheckrange (since last tcheckrange atoms
    %     won't be able to test if the cross was successful
    %     Loop to determine position (in terms of layers) of molecule at time t
    t=2;
    while t <= tot_time-tcheckrange
        p = coord(t,i);
        if (p > layer_pos(half)) && (p <= layer_pos(half+1))
            pos = half+1;
        elseif p > layer_pos(nboundary)
            pos = nregion;
        else
            for l=lcheck
                if p <= layer_pos(l)
                    pos = l;
                    break;
                end
            end
        end
        
        
        
        LayerPopulation(pos) = LayerPopulation(pos) + 1;
        
        % Crossing may have occured if pos ~= pos_prev
        % Otherwise corssing definitely has not occured
        if (pos ~= pos_prev)
            
            % cross is succesful if it is still in new layer or if it is
            % in a different layer (ie progressed further) after
            % tcheckrange additional frames
            failed_cross = false;
            for t_stay=t+1:t+ tcheckrange
                pp = coord(t_stay,i);
                
                % check if new position at t_stay is NOT in original pos.
                if (pos_prev == half+1)
                    if (pp > layer_pos(half)) && (pp <= layer_pos(half+1))
                        failed_cross = true;
                        break;
                    end
                elseif (pos_prev == nregion)
                    if pp > layer_pos(nboundary)
                        failed_cross = true;
                        break;
                    end
                elseif (pos_prev == 1)
                    if pp <= layer_pos(1)
                        failed_cross = true;
                        break;
                    end
                else
                    if (pp <= layer_pos(pos_prev)) && (pp > layer_pos(pos_prev-1))
                        failed_cross = true;
                        break;
                    end
                end
            end
            
            % If the crossing "failed" skip to t_stay +1 as we know that no
            % other crossings occured in that time frame (and speeds up code)
            %
            % In order to update LayerPopulation list for skipped frames
            % assume molecule has been in layer "pos" until time t_stay at
            % which point it has returned to pos_prev
            %
            % Assumption for population: molecule has remained in pos and
            % not crossed further during time t+1 to t_stay -1.
            if failed_cross == true
                for time = t+1:t_stay-1
                    LayerPopulation(pos) = LayerPopulation(pos) +1;
                end
                LayerPopulation(pos_prev) = LayerPopulation(pos_prev) +1;
                t = t_stay +1;
                
                continue;
            end
            
            %% If crossing succcessful:
            %  a=1 is crossing towards bulk
            %  a=2 is crossing towards surface
            %  Absolute direction (left or right) of crossing opposite for
            %  top half and bottom half. Taken into account below
            %  bound ranges from 1 to nboundaries
            
            
            if pos <= half                  %if first half (bottom)
                if pos > pos_prev
                    bound = pos_prev;
                    a=1;
                else
                    bound = pos;
                    a=2;
                end
            elseif pos == half + 1          %if middle
                if pos_prev == half
                    bound = pos_prev;
                    a = 1;
                elseif pos_prev == half + 2
                    bound = pos;
                    a = 1;
                end
            else                            % if second half. Swapped (top)
                if pos < pos_prev
                    bound = pos;
                    a =1;
                else
                    bound = pos_prev;
                    a =2;
                end
            end
            
            LayerCross{a}(bound) = LayerCross{a}(bound) + 1;
            
            if (a == 1) && (bound == bound_id(a))
                if t>2
                    countCross = countCross +1;
                    cross_id(countCross,:) = [t,i];
                end
            end
            
            
            
        end % end if crossed - only reach here if cross successful
        % Update time and pos_prev for succesful crosses:
        t= t+1;
        pos_prev = pos;
    end % end while lopp
end % end num atoms


%% OUTPUT DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Determine number of crossings per ns for each boundary:
for i=1:nboundary
    for a=1:2
        LayerCross{a}(i) = LayerCross{a}(i)*convns;
    end
end

% Average number of molecules in each layer:
LayerPopulation = LayerPopulation/(tot_time-tcheckrange);

%% Calculate life time of regions:
% Numbered 1 to nboundary.
% For boundary 1: A is lifetime of region 1 (decay to region 2)
% B is lifetime of region 2 (decay to region 1)

for i=1:half
    lifetime{A}(i) = LayerPopulation(i)./LayerCross{A}(i);
    lifetime{B}(i) = LayerPopulation(i+1)./LayerCross{B}(i);
end
for i=half+1:nboundary
    lifetime{A}(i) = LayerPopulation(i+1)./LayerCross{A}(i);
    lifetime{B}(i) = LayerPopulation(i)./LayerCross{B}(i);
end


end

