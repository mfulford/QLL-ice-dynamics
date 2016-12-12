clear all; close all; clc;

%% Analyse dynamics at the QLL/ice interface. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  run_cross: Calculate rate of diffusion across the QLL/ice interface  
%  run_remain: Calculate decay/lifetime of molecules in layers 
%  reorientation: Analyse reorientation of molecules after diffusion across
%  QLL/ice interface
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% What to Run? %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  Run and plot crossing code?
run_cross = true;
plot_cross = true;

% Run layer remainign code?
run_remain = false;

% Plot density profiles? true if you want to 
plot_fig = false; %true;

% Run reorientation code? Will only work if running cross
reorientation = false; 

% Run on minima? (ie boundaries == true) or maximima (ie on middle of
% layers == false)
min_not_max = true; 

import_boundaries = false; 

%% Initialise Input Parameters: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Total number of boundaries: prism ~ 39, basal ~ 49
n_boundaries = 20; n_regions = n_boundaries +1;
n_halfbound = n_boundaries/2;

% # bins for Histograms
nbins = 5000; 
num_ox = 5760;
temp          = [240, 245, 250, 255, 260, 265, 270]; 
temp_length_p = [100, 100, 100, 100, 100, 100, 427];
temp_length   = [100, 100, 100, 100, 100, 100, 413];
temp_string   = {'240K' '245K' '250K' '255K' '260K' '265K' '270K'};
num_temps = length(temp); 

% number of frames to discard. 200 frames = 1 ns. 
discard_initial = [10 10 10 10 10 10 50].*200;

for i=1:num_ox
    atomlist(i) = (i-1)*3 +1;
    atomlist_ox(i) = i;
end

% boundaries of importance for plotting later: 
% q3 values (NOT USED - IMPORTED FROM FILE):
bound_q3_p = [1, 1, 1, 1, 2, 2, 2];
bound_q3_b = [2, 1, 1, 1, 1, 1, 3];
bound_p = [1, 1, 1, 1, 2, 2, 3];
bound_b = [1, 1, 1, 1, 1, 2, 4];
 
%Ebarrier density values  1.0KT:
bound_E_p = [1, 1, 1, 1, 1, 2, 2];
bound_E_b = [1, 1, 1, 1, 1, 1, 3];

%10 splits 1.0kT
bound_E_all_270_p{1} = [3 3 2 2 3 2 3 2 2 3];
bound_E_all_270_p{2} = [2 2 2 2 2 2 2 2 3 2];

bound_E_all_270_b{1} = [1 3 3 3 1 3 5 3 1 3];
bound_E_all_270_b{2} = [5 3 3 3 1 3 1 3 3 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% time range for deciding if cross is sucessful. 100 == 0.5 ns 150 == 0.75ns
% 20 == 0.1ns  2 == 0.01ns 400 == 2ns
tcheckrange = 200; 
densE_values = true;

%% Loop over temperatures and read in dcd trajectories

for tt=1:num_temps
    for phase=1:2 
    
        fprintf('Temperature %dK \n', temp(tt));
        % IMPORT DATA: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if phase==1
            fprintf('Read in: Basal');      

            basalfile = sprintf('/home/k1338457/driveB/MD/tip4p/basal/%dK/TrajectOx_Basal%dK_NVTMD_tip4p_%dnsAll.dcd', temp(tt),temp(tt),temp_length(tt));
            orientfile_b = sprintf('/home/k1338457/driveB/MD/tip4p/basal/%dK/dangling_q3m/orient_frame.txt', temp(tt));
            boundfile_b =  sprintf('/home/k1338457/driveB/MD/tip4p/basal/%dK/interface_boundaries.txt', temp(tt));
            if min_not_max == false
                boundfile_b =  sprintf('/home/k1338457/driveB/MD/tip4p/basal/%dK/interface_boundaries_maxima_freenergyminima.txt', temp(tt));
            end

            remainfile_b = sprintf('/home/k1338457/driveB/MD/tip4p/basal/%dK/remain_MD_%dK_basal.txt', temp(tt),temp(tt));
            interfacefile_b = sprintf('/home/k1338457/driveB/MD/tip4p/basal/%dK/layer_q3/up_down/qll_interface_position.txt', temp(tt));
            if temp(tt) == 270
                interfacefile_b = sprintf('/home/k1338457/driveB/MD/tip4p/basal/%dK/layer_q3/up_down/split/10_splits/qll_interface_position.txt', temp(tt));
            end

            densfile_b =  sprintf('/home/k1338457/driveB/MD/tip4p/basal/%dK/density_profile.txt', temp(tt));
            import_x = false; import_y = true; import_z = false;
            [dummy_x, ycoord_b, dummy_z]     = readdcd(basalfile,atomlist_ox,import_x, import_y, import_z);
            [tot_nframe_b, nats] = size(ycoord_b);
            ycoord_b(1:discard_initial(tt),:) = [];
            [nframe_b, nats] = size(ycoord_b);
            frame_b{tt} = [1:1:length(ycoord_b)]./200; % == timestep in ns

        elseif phase == 2

            fprintf(', Prism \n');
            prismfile = sprintf('/home/k1338457/driveB/MD/tip4p/prism/%dK/TrajectOx_Prism%dK_NVTMD_tip4p_%dnsAll.dcd', temp(tt),temp(tt), temp_length_p(tt));
            orientfile_p = sprintf('/home/k1338457/driveB/MD/tip4p/prism/%dK/dangling_q3m/orient_frame.txt', temp(tt));
            boundfile_p =  sprintf('/home/k1338457/driveB/MD/tip4p/prism/%dK/interface_boundaries.txt', temp(tt));
             if min_not_max == false
                boundfile_p =  sprintf('/home/k1338457/driveB/MD/tip4p/prism/%dK/interface_boundaries_maxima_freenergyminima.txt', temp(tt));
            end
            remainfile_p =  sprintf('/home/k1338457/driveB/MD/tip4p/prism/%dK/remain_MD_%dK_prism.txt', temp(tt),temp(tt), temp_length_p(tt));
            interfacefile_p = sprintf('/home/k1338457/driveB/MD/tip4p/prism/%dK/layer_q3/up_down/qll_interface_position.txt', temp(tt));
            if temp(tt) == 270
                interfacefile_p = sprintf('/home/k1338457/driveB/MD/tip4p/prism/%dK/layer_q3/up_down/split/10_splits/qll_interface_position.txt', temp(tt));
            end

            densfile_p =  sprintf('/home/k1338457/driveB/MD/tip4p/prism/%dK/density_profile.txt', temp(tt));
            if temp(tt) == 255
                prismfile = sprintf('/home/k1338457/driveB/MD/tip4p/prism/%dK/TrajectOx_Prism255K_repeat_NVTMD_tip4p_100nsAll.dcd', temp(tt));
            end
            import_x = true; import_y = false; import_z = false;
            [xcoord_p, dummy_y, dummy_z]     = readdcd(prismfile,atomlist_ox,import_x, import_y, import_z);
            xcoord_p(1:discard_initial(tt),:) = [];
            [nframe_p, nats] = size(xcoord_p);
            frame_p{tt} = [1:1:length(xcoord_p)]./200; % == timestep in ns
        end

        %% Determine position of layer boundaries by plotting density profile 

        if phase == 1

            fprintf('Determine Boundary: Basal \n');

            is_basal240 = false; 
            if tt == 1
                is_basal240 = true;
            end

            [layer_b{tt}, layer_b_OTHER{tt}, middle_b{tt}, layer_deep] = ...
                boundaries(is_basal240,min_not_max, ycoord_b, nbins, n_halfbound, ' Basal', temp_string{tt}, plot_fig, bound_b(tt), densfile_b, nframe_b);

            fid_b=fopen(boundfile_b,'w');
            fprintf(fid_b, '%i %f %f \n', length(layer_b{tt}), layer_b{tt}(bound_b(tt)), layer_b{tt}(end -bound_b(tt)+1));
            fprintf(fid_b, '%f \n', layer_b{tt});
            fclose(fid_b); 

        elseif phase == 2 

            fprintf('Determine Boundary: Prism \n');
            is_basal240 = false; 

            [layer_p{tt}, layer_p_OTHER{tt}, middle_p{tt}, layer_deep] = ...
                boundaries(is_basal240,min_not_max,xcoord_p, nbins, n_halfbound, ' Prism', temp_string{tt}, plot_fig, bound_p(tt), densfile_p, nframe_p);

            fid_p=fopen(boundfile_p,'w');
            fprintf(fid_p, '%i %f %f \n', length(layer_p{tt}), layer_p{tt}(bound_p(tt)), layer_p{tt}(end -bound_p(tt)+1) ); 
            fprintf(fid_p, '%f \n', layer_p{tt});
            fclose(fid_p);

        end


        %% Determine frequency of layer crossings using boundary positions
        %  and determine the average population of each layer
        if run_cross == true
            n_times = 10;
            fprintf('Calculate layer crossings: ');
            if phase==1

                fprintf(', Basal: \n');

                fid = fopen(interfacefile_b);
                data=textscan(fid,'%f %f','Headerlines',1);
                bound_q3_all{1} = data{1}';
                bound_q3_all{2} = data{2}';
                bound_q3(1) = round(mean(bound_q3_all{1}));
                bound_q3(2) = round(mean(bound_q3_all{2})); 
                bound_E(1) = bound_E_b(tt); 
                bound_E(2) = bound_E_b(tt); 
                bound_E_all_270 = bound_E_all_270_b;
                clear data; 

                [n_tmp naaa] = size(ycoord_b); 
                n_split = n_tmp/n_times;
                for split=1:n_times
                    split_start = 1 + (split-1)*n_split;
                    split_end = n_split + (split-1)*n_split;
                    if temp(tt) < 270
                        bound(1) = bound_q3_all{1};
                        bound(2) = bound_q3_all{2}; 
                    else 
                        tmp_for40 = 1;
                        bound(1) = bound_q3_all{1}(tmp_for40); 
                        bound(2) = bound_q3_all{2}(tmp_for40); 
                    end

                    [LayerCross_TMP{split}, LayerPop_TMP{split}, lifetime_TMP{split}, cross_id_b{split}] ...
                        = coord_layerCross(tcheckrange, min_not_max, ycoord_b(split_start:split_end,:), ...
                          layer_b{tt}, layer_b_OTHER{tt}, middle_b{tt}, n_boundaries, n_regions, layer_deep, bound);
                end

            elseif phase==2

                fprintf('Prism \n');

                fid = fopen(interfacefile_p);
                data=textscan(fid,'%f %f','Headerlines',1);
                bound_q3_all{1} = data{1}';
                bound_q3_all{2} = data{2}';
                bound_q3(1) = round(mean(bound_q3_all{1}));
                bound_q3(2) = round(mean(bound_q3_all{2})); 
                bound_E(1) = bound_E_p(tt); 
                bound_E(2) = bound_E_p(tt);
                bound_E_all_270 = bound_E_all_270_p;
                clear data; 

                [n_tmp, naaa] = size(xcoord_p); 
                n_split = n_tmp/n_times;
                for split=1:n_times
                    split_start = 1 + (split-1)*n_split;
                    split_end = n_split + (split-1)*n_split;
                    if temp(tt) < 270
                        bound(1) = bound_q3_all{1};
                        bound(2) = bound_q3_all{2};
                    else 
                        tmp_for40 = 1;
                        bound(1) = bound_q3_all{1}(tmp_for40); 
                        bound(2) = bound_q3_all{2}(tmp_for40); 
                    end

                    [LayerCross_TMP{split}, LayerPop_TMP{split}, lifetime_TMP{split}, cross_id_p{split}] ...
                        = coord_layerCross(tcheckrange, min_not_max, xcoord_p(split_start:split_end,:), ...
                            layer_p{tt}, layer_p_OTHER{tt}, middle_p{tt}, n_boundaries, n_regions, layer_deep, bound);
                end

                fprintf('Completed layer crossings \n');
            end

            %%  Simplify Crossing data for plotting  %%%%%%%%%%%%%%%%%%%%%%
            %   Bottom surface = 1, l=jj;
            %   Top surface = 2,  l=nboundary-jj+1;

            for surf=1:2
                for dir=1:2

                    for spl=1:n_times
                        if surf == 1
                            b_q3 = bound_q3(surf);
                            b_E  = bound_E(surf); 
                        elseif surf == 2
                            b_q3 = n_boundaries - bound_q3(surf) +1;
                            b_E = n_boundaries - bound_E(surf) +1;
                        end
                        if tt == 7
                            if surf == 1
                                b_E = bound_E_all_270{surf}(spl);
                                b_q3 = bound_q3_all{surf}(spl); 
                            elseif surf == 2
                                b_E = n_boundaries - bound_E_all_270{surf}(spl) +1; 
                                b_q3 = n_boundaries - bound_q3_all{surf}(spl) +1;
                            end 
                        end
                        if spl == 1
                            bb_q3 = LayerCross_TMP{spl}{dir}(b_q3);
                            bb_E  = LayerCross_TMP{spl}{dir}(b_E);
                        else
                            bb_q3 = [bb_q3; LayerCross_TMP{spl}{dir}(b_q3)];
                            bb_E  = [bb_E;  LayerCross_TMP{spl}{dir}(b_E)];
                        end                     
                    end

                    if phase == 1
                        rate_interface_q3_b{surf}{dir}(tt) = mean(bb_q3);
                        std_interface_q3_b{surf}{dir}(tt)  = std(bb_q3);
                        rate_interface_E_b{surf}{dir}(tt) = mean(bb_E);
                        std_interface_E_b{surf}{dir}(tt)  = std(bb_E);
                    elseif phase == 2
                        rate_interface_q3_p{surf}{dir}(tt) = mean(bb_q3);
                        std_interface_q3_p{surf}{dir}(tt)  = std(bb_q3);
                        rate_interface_E_p{surf}{dir}(tt) = mean(bb_E);
                        std_interface_E_p{surf}{dir}(tt)  = std(bb_E);
                    end

                    clear bb_q3; clear bb_E; 

                    for jj=1:n_halfbound
                        l = (surf-1)*n_boundaries + (1-surf)*(jj-1) + (2-surf)*jj;

                        for spl=1:n_times
                            if (spl == 1) && (dir == 1)
                                av(l) =  LayerCross_TMP{spl}{dir}(l);
                            else 
                                av(l) = av(l) + LayerCross_TMP{spl}{dir}(l);
                            end
                            if spl == 1
                                rr = LayerCross_TMP{spl}{dir}(l);
                                ll = lifetime_TMP{spl}{dir}(l);                           
                            else
                                rr = [rr; LayerCross_TMP{spl}{dir}(l)];
                                ll = [ll; lifetime_TMP{spl}{dir}(l)];
                            end
                        end

                        if phase == 1
                            rate_b{surf}{dir}{jj}(tt) = mean(rr);
                            life_b{surf}{dir}{jj}(tt) = mean(ll);
                            std_rate_b{surf}{dir}{jj}(tt) = std(rr);
                            std_life_b{surf}{dir}{jj}(tt) = std(ll);
                        elseif phase == 2
                            rate_p{surf}{dir}{jj}(tt) = mean(rr);
                            life_p{surf}{dir}{jj}(tt) = mean(ll);
                            std_rate_p{surf}{dir}{jj}(tt) = std(rr);
                            std_life_p{surf}{dir}{jj}(tt) = std(ll);
                        end
                        clear rr; clear ll;
                    end
                end

                for jj=1:n_halfbound
                    l = (surf-1)*n_boundaries + (1-surf)*(jj-1) + (2-surf)*jj;
                    rate_b_av{surf}{jj}(tt) = av(l)/(2*n_times); 
                end
                clear av; 
            end

            for dir=1:2
                for spl=1:n_times
                    b_q3_s1 = bound_q3(1);
                    b_E_s1  = bound_E(1); 
                    b_q3_s2 = n_boundaries - bound_q3(2) +1;
                    b_E_s2 = n_boundaries - bound_E(2) +1;
                    if tt == 7
                        b_E_s1 = bound_E_all_270{1}(spl);
                        b_E_s2 = n_boundaries - bound_E_all_270{2}(spl) +1; 
                        b_q3_s1 = bound_q3_all{1}(spl); 
                        b_q3_s2 = n_boundaries - bound_q3_all{2}(spl) +1;
                    end
                    if spl == 1
                        bb_q3_bothsurf = [LayerCross_TMP{spl}{dir}(b_q3_s1); LayerCross_TMP{spl}{dir}(b_q3_s2)];
                        bb_E_bothsurf = [LayerCross_TMP{spl}{dir}(b_E_s1); LayerCross_TMP{spl}{dir}(b_E_s2)];
                    else
                        bb_q3_bothsurf = [bb_q3_bothsurf; LayerCross_TMP{spl}{dir}(b_q3_s1); LayerCross_TMP{spl}{dir}(b_q3_s2)];
                        bb_E_bothsurf = [bb_E_bothsurf; LayerCross_TMP{spl}{dir}(b_E_s1); LayerCross_TMP{spl}{dir}(b_E_s2)];
                    end
                end
                if phase == 1
                    rate_interface_q3_bothsurf_b{dir}(tt) = mean(bb_q3_bothsurf);
                    std_interface_q3_bothsurf_b{dir}(tt)  = std(bb_q3_bothsurf);

                    rate_interface_E_bothsurf_b{dir}(tt) = mean(bb_E_bothsurf);
                    std_interface_E_bothsurf_b{dir}(tt)  = std(bb_E_bothsurf);
                elseif phase == 2
                    rate_interface_q3_bothsurf_p{dir}(tt) = mean(bb_q3_bothsurf);
                    std_interface_q3_bothsurf_p{dir}(tt)  = std(bb_q3_bothsurf);

                    rate_interface_E_bothsurf_p{dir}(tt) = mean(bb_E_bothsurf);
                    std_interface_E_bothsurf_p{dir}(tt)  = std(bb_E_bothsurf);
                end
                clear bb_q3_bothsurf; clear bb_E_bothsurf;
            end

            for l=1:n_regions
                pop = LayerPop_TMP{split};
                for spl=2:n_times
                    pop = [pop; LayerPop_TMP{spl}(l)];
                end
                if phase == 1
                    LayerPop_p{tt}{spl} = mean(pop);
                elseif phase == 2
                    LayerPop_b{tt}{spl} = mean(pop);
                end
            end

            A = 1; B=2;
            for l=1:n_boundaries
                lcA = LayerCross_TMP{1}{A}(l); 
                lcB = LayerCross_TMP{1}{B}(l);
                lifeA = lifetime_TMP{1}{A}(l); 
                lifeB = lifetime_TMP{1}{B}(l);
                for spl=2:n_times
                    lcA = [lcA; LayerCross_TMP{spl}{A}(l)]; 
                    lcB = [lcB; LayerCross_TMP{spl}{B}(l)];

                    lifeA = [lifeA; lifetime_TMP{spl}{A}(l)];
                    lifeB = [lifeB; lifetime_TMP{spl}{B}(l)];
                end
                if phase == 1    
                    LayerCross_b{tt}{A}(l)     = mean(lcA); 
                    LayerCross_b_std{tt}{A}(l) = std(lcA);

                    LayerCross_b{tt}{B}(l)     = mean(lcB); 
                    LayerCross_b_std{tt}{B}(l) = std(lcB);

                    lifetime_b{tt}{A}(l)       = mean(lifeA);
                    lifetime_b{tt}{B}(l)       = mean(lifeB);

                elseif phase == 2
                    LayerCross_p{tt}{A}(l)     = mean(lcA);
                    LayerCross_p_std{tt}{A}(l) = std(lcA);

                    LayerCross_p{tt}{B}(l)     = mean(lcB);
                    LayerCross_p_std{tt}{B}(l) = std(lcB);  

                    lifetime_p{tt}{A}(l)       = mean(lifeA);
                    lifetime_p{tt}{B}(l)       = mean(lifeB);
                end
            end

           clear LayerCross_TMP; clear LayerPop_TMP; clear lifetime_TMP;

        end % Crossing Analysis Completed %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %% Reorientation of molecules before/after crossing layer %%%%%%%%%   
        if reorientation == true
            if phase == 1
                crossing_reorientation(tt, 1, ' Basal', temp_string{tt}, ...
                    orientfile_b, cross_id_b, discard_initial(tt), nframe_b);
            elseif phase == 2
                crossing_reorientation(tt, 2, ' Prism', temp_string{tt}, ...
                    orientfile_p, cross_id_p, discard_initial(tt), nframe_p);
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %% Calculate the number of initial QLL mols remaining with time
        if run_remain == true
            if phase == 1

                [n_remain_b{tt}, half_frame_b{tt}] = layer_remaining(ycoord_b, layer_b{tt}, bound_b(tt));
                [kappa_b(tt), kappafit_b{tt}] = layer_remain_fit(frame_b{tt}',n_remain_b{tt}{1});

                fid_b=fopen(remainfile_b,'w');
                fprintf(fid_b, '# Column 1: timestep, Column 2: n_remaining \n');

                for row=1:length(frame_b{tt})
                    fprintf(fid_b, '%f %f \n', frame_b{tt}(row) ,n_remain_b{tt}{1}(row));
                end
                fclose(fid_b);

            elseif phase == 2 

                [n_remain_p{tt}, half_frame_p{tt}] = layer_remaining(xcoord_p, layer_p{tt}, bound_p(tt));
                [kappa_p(tt), kappafit_p{tt}] = layer_remain_fit(frame_p{tt}',n_remain_p{tt}{1});
                fid_p=fopen(remainfile_p,'w');
                fprintf(fid_p, '# Column 1: timestep, Column 2: n_remaining \n');
                for row=1:length(frame_p{tt})
                    fprintf(fid_p, '%f %f \n', frame_p{tt}(row) ,n_remain_p{tt}{1}(row));
                end
                fclose(fid_p);
            end

        end % Remain Analysis Completed %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %% Completed all analysis for tranjectory. Clear coordinates
        if phase == 1
            clear ycoord_b;
        elseif phase == 2
            clear xcoord_p;
        end

    end  % End loop over phases
    
end  % END MAIN TEMPERATURE LOOP


%% PLOTTING DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if plot_cross == true
    % CoordCross_plot(tcheckrange, temp, num_temps, temp_string, bound_b, bound_p, layer_b, layer_p, ...
    %    LayerCross_b, LayerCross_b_std, LayerCross_p, LayerCross_p_std, ...
    %    rate_b, std_rate_b, rate_p, std_rate_p, life_b, life_p, LayerPop_b, LayerPop_p);
    
    PlotCrossFreq_Only(rate_interface_q3_b, std_interface_q3_b, rate_interface_q3_p, std_interface_q3_p, ...
        rate_interface_E_b, std_interface_E_b, rate_interface_E_p, std_interface_E_p, ...
        rate_interface_q3_bothsurf_b, std_interface_q3_bothsurf_b, rate_interface_q3_bothsurf_p, std_interface_q3_bothsurf_p, ...
        rate_interface_E_bothsurf_b, std_interface_E_bothsurf_b, rate_interface_E_bothsurf_p, std_interface_E_bothsurf_p)
end


if run_remain == true
    LayerRemain_Plot(temp, num_temps, temp_string, n_remain_p, n_remain_b, frame_p, frame_b, half_frame_p, half_frame_b, kappa_p, kappa_b, kappafit_p, kappafit_b)
end
