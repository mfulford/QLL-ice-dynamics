function [orientCrossFrame] = crossing_reorientation(t, phase_num, phaseN, temp_string, orientfile, cross_id, discard_initial, nframe)
%% Analyse reorientation of molecules following layer crossing
%  Keep record of orientation immediately prior and post crossing
%  Frames written every 5000 fms (5ps) so maybe not enough data do study
%  mechanism
%  Plot histograms of orientation of molecules at frames before and after crossing

% 1st col is frame, 2nd is id of molecule
% sort using 1st column in ascending order of time
sort_cross =  sortrows(cross_id);

% how many time frames to study reorientation over?
n_keep = 4;

% range for 2-d histogram colour bar
colourscale{1} = [6,   9, 10, 18, 24, 36, 49]; 
colourscale{2} = [15, 21, 26, 26, 25, 22, 62]; 

% count of crossing number
count = 0;

% import data in blocks of 5760 (number of molecules per frame).
% discard initial frames which didn't perform crossing analysis on
orientID = fopen(orientfile); formatSpec = '%f %f';

keep_discarded = discard_initial - n_keep +1;
for f=1:discard_initial
    test = textscan(orientID,formatSpec,5760,'HeaderLines',1,'CommentStyle','#','Delimiter','\t');
    
    % keep frames in case crossing occurs within n_keep frames in next section
    if f>=keep_discarded
        ff = f - keep_discarded +1;
        orient_keep{ff} = test;
    end
end

%% Begin main loop

CrossTrue = false;
for f=1:nframe
    
    test = textscan(orientID,formatSpec,5760,'HeaderLines',1,'CommentStyle','#','Delimiter','\t');
    
    % only keep n frames (frame 1 is oldest and n is current)
    orient_keep(:,1) = [];
    orient_keep{n_keep} = test;
    
    
    % loop over number of crossings
    % if frame is == to a frame when crossing occurs then enter
    % n_cross is number of unique crossing events (can be the same molecule more than once)
    n_cross = size(sort_cross,1);
    for c=1:n_cross
        if f == sort_cross(c,1);
            CrossTrue = true;
            count = count+1;
            AT_id = sort_cross(c,2); % id of atom which crossed
            
            % info to help us add the orient data after crossing
            % f+n_keep tells us which frame to add post crossing data
            if exist('poscross_id') == 0
                n_finished = 0;
            else
                n_finished = size(poscross_id,1);
            end
            poscross_id(n_finished+1,:) = [AT_id, f+n_keep, count];
            
            for pre=1:n_keep
                orientCrossFrame{count}{1}(pre) = orient_keep{pre}{1}(AT_id);
                orientCrossFrame{count}{2}(pre) = orient_keep{pre}{2}(AT_id);
            end
            
            % keep record of crossings which have been analysed
            if exist('del_cross') == 0
                del_cross(1) = c;
            else
                del_cross(end+1) = c;
            end
            
            % since sort_cross ordered in ascending time, if f is greater
            % then can end loop over crossings c and proceed to next time
            % frame f
        elseif f > sort_cross(c,1);
            break;
        end
    end
    
    % remove from record any crossing which has just been (pre) analysed
    % speed up loop (these crossings wouldn't have been visited again as
    % future f would be greater than frame c (as ordered in ascending order)
    if exist('del_cross') > 0
        sort_cross(del_cross,:) = [];
        clear del_cross;
    end
    
    % n_finished is number of crossings which need to be post analysed
    % ie reorientation after crossing event
    % If frame is tend, then orient_keep contains all the frames necessary
    % for post analysis of AT_id
    if CrossTrue == true
        n_finished = size(poscross_id,1);
        % loop over crossings which haven't been post analysed
        for i=1:n_finished
            tend = poscross_id(i,2); % time/frame until which reorientation to be analysed
            if f == tend
                AT_id = poscross_id(i,1);
                count_id = poscross_id(i,3);
                for post=1:n_keep
                    ppost = post+n_keep;
                    orientCrossFrame{count_id}{1}(ppost) = orient_keep{post}{1}(AT_id);
                    orientCrossFrame{count_id}{2}(ppost) = orient_keep{post}{2}(AT_id);
                end
                
                % delete any completed post crossings from poscross_id
                if exist('fdel') == 0
                    fdel(1) = i;
                else
                    fdel(end+1) = i;
                end
            end
        end
    end
    
    if exist('fdel') > 0
        poscross_id(fdel,:) = [];
        clear fdel;
    end
    
end

for i=1:size(orientCrossFrame,2)-1
    for k=1:n_keep*2
        data{k}(i,:) = [orientCrossFrame{i}{1}(k), orientCrossFrame{i}{2}(k)];
    end
end

%% Plot histograms of orientation of molecules at frames before and after crossing:

figure;
for k=1:n_keep*2
    subplot(2,n_keep,k);
    ax = gca;
    title([temp_string,phaseN]);
    histogram2(data{k}(:,1),data{k}(:,2),19,'DisplayStyle','tile','ShowEmptyBins','off','EdgeColor','none');
    colorbar;
    
    caxis([0,colourscale{phase_num}(t)]);
    if (k == 1)
        title([temp_string,phaseN]);
    elseif (k == 2)
        title('t - 2');
    elseif (k == 3)
        title('t - 1');
    elseif (k == 4)
        title('Crossing occured')
    elseif (k == 5)
        title('t + 1');
    elseif (k == 6)
        title('t + 2');
    elseif (k == 7)
        title('t + 3');
    elseif (k == 8)
        title('t + 4');
        colorbar;
    end
end

end

