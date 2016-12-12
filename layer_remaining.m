function [ n_remain, half_frame  ] = layer_remaining(coord, layer_pos, qll_id)
% Monitor number of molecules initially in layer at time 0 still in layer at time t

[tot_time num_atoms] = size(coord);
tot_nlayers = length(layer_pos);
count(1) = 0;
count(2) = 0;

%% Determine id of atoms initially in layer qll_id:
for i=1:num_atoms
    p = coord(1,i);
    if p < layer_pos(qll_id) % bottom
        count(1) = count(1) +1;
        id_vector{1}(count(1)) = i;
        
    elseif p > layer_pos(tot_nlayers-qll_id+1) % top
        count(2) = count(2) +1;
        id_vector{2}(count(2)) = i;
        
    end
end

for surf=1:2
    n_layer(surf) = length(id_vector{surf});
    n_original(surf) = n_layer(surf);
    n_remain{surf} = zeros(tot_time,1);
    %     number remaining at time 1 (== time 0):
    n_remain{surf}(1) = n_layer(surf);
end


%% NEW: count how many mols in layer at time 1 (unchaged)
%  if molecule crosses out at time t, then in future steps ignore this
%  molecule altogether. Therefore, nremain will not reach a steady state
%  and tend to 0 eventually.
%% Bottom surface
for t=2:tot_time;
    count = 0;
    for i=1:n_layer(1)
        p = coord(t,id_vector{1}(i));
        if p < layer_pos(qll_id)
            n_remain{1}(t) = n_remain{1}(t) + 1;
        else
            count = count +1;
            id_delete(count) = i;
        end
    end
    
    % remove molecules which have crossed from future consideration
    % ie ignore them even if they cross back into the region
    if exist('id_delete') > 0
        id_vector{1}(id_delete) = [];
        n_layer(1) = length(id_vector{1});
        clear id_delete;
    end
end



%% Top surface
for t=2:tot_time;
    count = 0;
    for i=1:n_layer(2)
        p = coord(t,id_vector{2}(i));
        if p > layer_pos(tot_nlayers-qll_id+1)
            n_remain{2}(t) = n_remain{2}(t) + 1;
        else
            count = count +1;
            id_delete(count) = i;
        end
    end
    
    if exist('id_delete') > 0
        id_vector{2}(id_delete) = [];
        n_layer(2) = length(id_vector{2});
        clear id_delete;
    end
end

for surf=1:2
    n_remain{surf} = n_remain{surf}/n_original(surf); %normalise so that it is fraction remaining
    
    %    determine frame when half molecules remaining
    %    use <= as 2 more than 1 mol may leave in one step and hence n_remain
    %    may never == exacatly 0.50
    for i=1:length(n_remain{surf})
        if n_remain{surf}(i) <= 0.10
            half_frame(surf) = i;
            break;
        end
        
    end
end

if (exist('half_frame') == false)
    half_frame(surf) = length(n_remain{surf}); % if didn't halve
end


end

