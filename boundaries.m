function [layer_pos, layer_pos_OTHER middle, layer_deep] = ...
    boundaries(is_basal240, min_not_max, coord, nbins, n_halfbound, ...
    phaseN, temp_string, plot_fig, bound, densfile, nframe)

%% Determine position of layer boundaries by plotting density profile
%  along "z"-axis and working out position of minima based where
%  gradient is 0 use peakdet function to determine boundaries.
%  Do for basal and prism surfaces and for all the temperatures
%  Uses lots of memory so need to clear data as go along

%% Determine Boundaries between Layers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Not plotting histogram to save time:
f  = figure;
hi =histogram(coord,nbins);
width = hi.BinWidth;
hi_midpoint = hi.BinEdges + width/2;

% delete last entry as outside range (edge has 1 extra value for outer bin)
hi_midpoint(nbins+1)=[];
% determine minima (mintab) in histogram (corresponding to boundary of layers)
peak_param = 5000;
if is_basal240 == true
    peak_param = 15000;
end

[maxtab, mintab] = peakdet(hi.Values, peak_param,hi_midpoint); % 1000 or 5000 good. 15000 ~ Parameter for how sensitive to height of peaks next to minima
midp = hi_midpoint;
val = hi.Values./nframe; %divide by total number of frames to make density in atomic units

fid=fopen(densfile,'w');
for row=1:length(midp)
    fprintf(fid, '%f %f \n', midp(row), val(row));
end
fclose(fid);

close(f);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Save Boundaries %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save n_halfbound top and bottom boundaries. Ignore middle bulk boundaries

% Determine position of "deep" bulk boundaries - bulk molecules which are very
% unlikely to cross into the regions we are monitoring (and hence can be
% ignored speeding up calculations)

if min_not_max == true
    n_totbound = length(mintab);
elseif min_not_max == false
    n_totbound = length(maxtab);
end

n_deepbulk = [n_halfbound + 5, n_totbound-n_halfbound+1 -5];

if min_not_max == true
    layer_deep = [mintab(n_deepbulk(1),1), mintab(n_deepbulk(2),1)];
elseif min_not_max == false
    layer_deep = [maxtab(n_deepbulk(1),1), maxtab(n_deepbulk(2),1)];
end

for i=1:n_halfbound
    
    %     Minima troughs:
    layer_pos_min(i) = mintab(i,1); % "Bottom"
    layer_pos_min(i+n_halfbound) = mintab(end-(n_halfbound-i),1); % "Top"
    %     Maxima - peaks:
    layer_pos_max(i) = maxtab(i,1); % "Bottom
    layer_pos_max(i+n_halfbound) = maxtab(end-(n_halfbound-i),1); % "Top"
    
end



% Save seperately boundary position of "middle" region.
% Middle region of bottom and top numbered the same later in code
if min_not_max == true
    middle(1) = mintab(n_halfbound+1,1); middle(2) = mintab(end-n_halfbound,1);
    layer_pos =  layer_pos_min;
    layer_pos_OTHER = layer_pos_max;
elseif min_not_max == false
    middle(1) = maxtab(n_halfbound+1,1); middle(2) = maxtab(end-n_halfbound,1);
    layer_pos =  layer_pos_max;
    layer_pos_OTHER = layer_pos_min;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ind = find(midp>= mintab(bound,1));
bot_min = min(ind);
ind = find(midp <= mintab(bound+1,1));
bot_max = max(ind);

ind = find(midp>= mintab(bound+1,1));
bot_post_min = min(ind);
ind = find(midp <= mintab(bound+2,1));
bot_post_max = max(ind);

ind = find(midp >= mintab(end-bound,1));
top_min = min(ind);
ind = find(midp <= mintab(end-bound+1,1));
top_max = max(ind);

ind = find(midp >= mintab(end-bound-1,1));
top_post_min = min(ind);
ind = find(midp <= mintab(end-bound,1));
top_post_max = max(ind);

if bound == 1
    bot_pre_min = 1;
    ind = find(midp <= mintab(bound,1));
    bot_pre_max = max(ind);
    
    ind = find(midp >= mintab(end,1));
    top_pre_min = min(ind);
    top_pre_max = length(val);
    
    
else
    ind = find(midp>= mintab(bound-1,1));
    bot_pre_min = min(ind);
    ind = find(midp <= mintab(bound,1));
    bot_pre_max = max(ind);
    
    
    ind = find(midp >= mintab(end-bound+1,1));
    top_pre_min = min(ind);
    ind = find(midp <= mintab(end-bound+2,1));
    top_pre_max = max(ind);
    
end

min_plot1 = -10; min_plot2 = 20;
max_plot1 = 70; max_plot2 = 100;
if phaseN == ' Prism'
    min_plot1 = -5; min_plot2 = 25;
    max_plot1 = 70; max_plot2 = 100;
elseif phaseN == ' Basal'
    min_plot1 = -10; min_plot2 = 20;
    max_plot1 = 65; max_plot2 = 95;
end

%% Plot Boundaries and Density profile %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If want to plot histogram with boundaries highlighted uncomment this:
if plot_fig == true
    figure;
    ax = gca;
    plot(midp,val,'k');
    hold on;
    
    harea = area(midp(bot_min:bot_max), val(bot_min:bot_max), 'EdgeColor','none', 'FaceColor','b','FaceAlpha', 0.5);
    hold on;
    harea2 = area(midp(bot_pre_min:bot_pre_max), val(bot_pre_min:bot_pre_max), 'EdgeColor','none', 'FaceColor','c','FaceAlpha', 0.5);
    hold on;
    harea3 = area(midp(bot_post_min:bot_post_max), val(bot_post_min:bot_post_max), 'EdgeColor','none', 'FaceColor','r','FaceAlpha', 0.5);
    hold on;
    harea = area(midp(top_min:top_max), val(top_min:top_max), 'EdgeColor','none', 'FaceColor','b','FaceAlpha', 0.5);
    hold on;
    harea2 = area(midp(top_pre_min:top_pre_max), val(top_pre_min:top_pre_max), 'EdgeColor','none', 'FaceColor','c','FaceAlpha', 0.5);
    hold on;
    harea3 = area(midp(top_post_min:top_post_max), val(top_post_min:top_post_max), 'EdgeColor','none', 'FaceColor','r','FaceAlpha', 0.5);
    hold on;
    
    plot(mintab(:,1), mintab(:,2), 'g*');
    hold on;
    plot(maxtab(:,1), maxtab(:,2), 'r*');
    title([temp_string,phaseN]);
    xlim([-20, 100]);
    ax.XTick = -20:10:120;
    ax.XRuler.MinorTick = 'on';
    ax.XRuler.MinorTickValues = [-20:1:100];
    ax.TickDir = 'Out';
    ax.TickLength = [0.025 0.035];
    ax.Box = 'off';
    
    
    figure;
    subplot(2,1,1)
    ax = gca;
    plot(midp,val,'k','LineWidth',1.5);
    hold on;
    
    harea = area(midp(bot_min:bot_max), val(bot_min:bot_max), 'EdgeColor','none', 'FaceColor','b','FaceAlpha', 0.5);
    hold on;
    harea2 = area(midp(bot_pre_min:bot_pre_max), val(bot_pre_min:bot_pre_max), 'EdgeColor','none', 'FaceColor','c','FaceAlpha', 0.5);
    hold on;
    harea3 = area(midp(bot_post_min:bot_post_max), val(bot_post_min:bot_post_max), 'EdgeColor','none', 'FaceColor','r','FaceAlpha', 0.5);
    hold on;
    
    plot(mintab(:,1), mintab(:,2), 'g*');
    hold on;
    plot(maxtab(:,1), maxtab(:,2), 'r*');
    title([temp_string,phaseN]);
    xlim([min_plot1, min_plot2]);
    ax.XTick = -10:5:20;
    ax.XRuler.MinorTick = 'on';
    ax.XRuler.MinorTickValues = [min_plot1:1:min_plot2];
    ax.TickDir = 'Out';
    ax.TickLength = [0.025 0.035];
    ax.Box = 'off';
    
    subplot(2,1,2)
    ax = gca;
    plot(midp,val,'k','LineWidth',1.5);
    hold on;
    
    harea = area(midp(top_min:top_max), val(top_min:top_max), 'EdgeColor','none', 'FaceColor','b','FaceAlpha', 0.5);
    hold on;
    harea2 = area(midp(top_pre_min:top_pre_max), val(top_pre_min:top_pre_max), 'EdgeColor','none', 'FaceColor','c','FaceAlpha', 0.5);
    hold on;
    harea2 = area(midp(top_post_min:top_post_max), val(top_post_min:top_post_max), 'EdgeColor','none', 'FaceColor','r','FaceAlpha', 0.5);
    hold on;
    
    
    plot(mintab(:,1), mintab(:,2), 'g*');
    hold on;
    plot(maxtab(:,1), maxtab(:,2), 'r*');
    xlim([ max_plot1, max_plot2]);
    ax.XTick = 70:5:100;
    ax.XRuler.MinorTick = 'on';
    ax.XRuler.MinorTickValues = [max_plot1:1:max_plot2];
    ax.TickDir = 'Out';
    ax.TickLength = [0.025 0.035];
    ax.Box = 'off';
    
end


end

