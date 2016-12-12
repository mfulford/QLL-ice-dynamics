function [ ] = CoordCross_plot(tcheckrange, temp, num_temps, temp_string, bound_b, bound_p, layer_b, layer_p, ...
    LayerCross_b, LayerCross_b_std, LayerCross_p, LayerCross_p_std, ...
    rate_b, std_rate_b, rate_p, std_rate_p, life_b, life_p, LayerPop_b, LayerPop_p)
%  Plot crossing frequency data
%  LayerCross_ can be plotted against boundary number or boundary
%  coordinate (== layer_) for a given temperature
%
%  rate_ can be plotted with temperature for a given surface and direction
%  and boundary
%
%  life_ is equivalent to rate_ except that it is lifetime

t_range_title = sprintf('Minimum time crossed: %2.2f ns', tcheckrange*0.005);

tmp_colour = get(gca,'colororder');
for t=1:num_temps
    plotcolour{t} = [tmp_colour(t,1) tmp_colour(t,2) tmp_colour(t,3)];
end

lims_on = false;

%%  BASAL Frequency of layer crossing v. coordinate of boundary %%%%%%%%%%%
%   Second number is direction
figure;
for t=1:num_temps
    ax = gca;
    errorbar(layer_b{t},LayerCross_b{t}{1}, LayerCross_b_std{t}{1},'-x','LineWidth',2);
    hold on;
    ylabel('Crossing Frequency (1/ns)');
    xlabel('Boundary Coordinate (\AA)');
    xlim([-5, 95]);
    ax.XTick = -5:10:95;
    ax.XRuler.MinorTick = 'on';
    ax.XRuler.MinorTickValues = [-5:2:95];
    ax.YRuler.MinorTick = 'on';
    ax.YRuler.MinorTickValues = [0:2:90];
end
title('Basal');
legend(temp_string,'Location','North');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PRISM Frequency of layer crossing v. coordinate of boundary %%%%%%%%%%%%
figure;
for t=1:num_temps
    ax = gca;
    errorbar(layer_p{t},LayerCross_p{t}{1},LayerCross_p_std{t}{1},'-x','LineWidth',2);
    hold on;
    ylabel('Crossing Frequency (1/ns)');
    xlabel('Boundary Coordinate (\AA)');
    xlim([-5, 95]);
    ax.XTick = -5:10:95;
    ax.XRuler.MinorTick = 'on';
    ax.XRuler.MinorTickValues = [-5:2:95];
    ax.YRuler.MinorTick = 'on';
    ax.YRuler.MinorTickValues = [0:2:90];
end
title('Prism');
legend(temp_string,'Location','North');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%   Basal: Plot freq v. temp for boundaries 1 to 5 %%%%%%%%%%%%%%%%%%%%%%% 
%    rate_b{surf}{dir}{jj}(tt)
figure;
for surf=1:2
    subplot(1,2,surf)
    for jj=1:5
        ax = gca;
        errorbar(temp,rate_b{surf}{1}{jj},std_rate_b{surf}{1}{jj},'-x','LineWidth',2);
        hold on;
        xlabel('Temperature (K)');
        if surf == 1
            ylabel('Crossing Frequency (1/ns)');
        end
        xlim([240, 270]);
        ax.XTick = 240:5:270;
        ax.XRuler.MinorTick = 'off';
        ax.YRuler.MinorTick = 'on';
        ax.YRuler.MinorTickValues = [0:2:90];
        ax.TickLength = [0.03 0.045];
        ax.FontSize = 14;
        ax.YLabel.FontSize = 18;
        ax.XLabel.FontSize = 18;
        ax.LineWidth = 1.5;
        ax.FontWeight = 'bold';
    end
    if surf == 1
        title('Basal');
        legend('Layer 1', 'Layer 2', 'Layer 3', 'Layer 4', 'Layer 5','Location','NorthWest');
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%   Prism: Plot freq v. temp for boundaries 1 to 5 %%%%%%%%%%%%%%%%%%%%%%%
figure;
for surf=1:2
    subplot(1,2,surf)
    for jj=1:5
        ax = gca;
        errorbar(temp,rate_p{surf}{1}{jj},std_rate_p{surf}{1}{jj},'-x','LineWidth',2);
        hold on;
        xlabel('Temperature (K)');
        if surf == 1
            ylabel('Crossing Frequency (1/ns)');
        end
        xlim([240, 270]);
        ax.XTick = 240:5:270;
        ax.XRuler.MinorTick = 'off';
        ax.YRuler.MinorTick = 'on';
        ax.YRuler.MinorTickValues = [0:2:90];
        ax.TickLength = [0.03 0.045];
        ax.FontSize = 14;
        ax.YLabel.FontSize = 18;
        ax.XLabel.FontSize = 18;
        ax.LineWidth = 1.5;
        ax.FontWeight = 'bold';
    end
    if surf == 1
        title('Prism');
        legend('Layer 1', 'Layer 2', 'Layer 3', 'Layer 4', 'Layer 5','Location','NorthWest');
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%   Prism and Basal: Plot freq v. temp for boundaries 1 to 5 %%%%%%%%%%%%%%%%%%%%%%%
figure;
for surf=1:2
    subplot(1,2,surf)
    for jj=1:3
        ax = gca;
        errorbar(temp,rate_p{surf}{1}{jj},std_rate_p{surf}{1}{jj},'-x','LineWidth',2,'Color',plotcolour{jj});
        hold on;
        errorbar(temp,rate_b{surf}{1}{jj},std_rate_b{surf}{1}{jj},'--+','LineWidth',2,'Color',plotcolour{jj});
        hold on;
        xlabel('Temperature (K)');
        if surf == 1
            ylabel('Crossing Frequency (1/ns)');
        end
        xlim([240, 270]);
        ax.XTick = 240:5:270;
        ax.XRuler.MinorTick = 'off';
        ax.YRuler.MinorTick = 'on';
        ax.YRuler.MinorTickValues = [0:2:90];
        ax.TickLength = [0.03 0.045];
        ax.FontSize = 14;
        ax.YLabel.FontSize = 18;
        ax.XLabel.FontSize = 18;
        ax.LineWidth = 1.5;
        ax.FontWeight = 'bold';
    end
    if surf == 1
        title('Prism and Basal');
        legend('P1', 'B1', 'P2', 'B2', 'P3', 'B3', 'Location','NorthWest');
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Life Time %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Plot lifetime %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plotlife = false;
if plotlife == true
    figure;
    for dir=1:2
        subplot(1,2,dir)
        ax = gca;
        plot(temp,pLT{dir}{1},'-bx','LineWidth',2);
        hold on;
        plot(temp,bLT{dir}{1},'-r*','LineWidth',2);
        hold on;
        
        plot(temp,pLT{dir}{2},'--bx','LineWidth',2);
        hold on;
        plot(temp,bLT{dir}{2},'--r*','LineWidth',2);
        
        xlabel('Temperature (K)');
        if dir == 1
            ylabel('Lifetime into Bulk (ns)');
        elseif dir == 2
            ylabel('Lifetime out of Bulk (ns)');
        end
        xlim([240, 270]);
        ax.XTick = 240:5:270;
        ax.XRuler.MinorTick = 'off';
        ax.YRuler.MinorTick = 'on';
        ax.YRuler.MinorTickValues = [0:2:120];
        ax.TickLength = [0.03 0.045];
        if dir == 1
            legend('Prism Surface 1', 'Basal Surface 1','Prism Surface 2', 'Basal Surface 2','Location','NorthWest');
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if plotlife == true
    %% Prism and Basal: LifeTime v. temp for boundaries 1 to 5 %%%%%%%%%%%%
    figure;
    for jj=1:3
        ax = gca;
        plot(temp,life_p{1}{1}{jj},'-x','LineWidth',2,'Color',plotcolour{jj});
        hold on;
        plot(temp,life_b{1}{1}{jj},'--+','LineWidth',2,'Color',plotcolour{jj});
        hold on;
        xlabel('Temperature (K)');
        ylabel('Life Time (ns)');
        xlim([240, 270]);
        ax.XTick = 240:5:270;
        ax.XRuler.MinorTick = 'off';
        ax.YRuler.MinorTick = 'on';
        ax.TickLength = [0.03 0.045];
        ax.FontSize = 14;
        ax.YLabel.FontSize = 18;
        ax.XLabel.FontSize = 18;
        ax.LineWidth = 1.5;
        ax.FontWeight = 'bold';
    end
    title('Prism and Basal');
    legend('P1', 'B1', 'P2', 'B2', 'P3', 'B3', 'Location','NorthWest');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

if plotlife == true
    %%   Prism and Basal: 1/LifeTime v. temp for boundaries 1 to 5 %%%%%%%%
    figure;
    for jj=1:3
        ax = gca;
        plot(temp,1./life_p{1}{1}{jj},'-x','LineWidth',2,'Color',plotcolour{jj});
        hold on;
        plot(temp,1./life_b{1}{1}{jj},'--+','LineWidth',2,'Color',plotcolour{jj});
        hold on;
        xlabel('Temperature (K)');
        ylabel('Cross Freq/mol (1/(ns mol))');
        xlim([240, 270]);
        ax.XTick = 240:5:270;
        ax.XRuler.MinorTick = 'off';
        ax.YRuler.MinorTick = 'on';
        ax.TickLength = [0.03 0.045];
        ax.FontSize = 14;
        ax.YLabel.FontSize = 18;
        ax.XLabel.FontSize = 18;
        ax.LineWidth = 1.5;
        ax.FontWeight = 'bold';
    end
    title('Prism and Basal');
    legend('P1', 'B1', 'P2', 'B2', 'P3', 'B3', 'Location','NorthWest');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

if plotlife == true
    
    figure;
    subplot(2,2,1)
    ax = gca;
    plot(temp,life_p{1}{1}{1},'-bx','LineWidth',2);
    hold on;
    plot(temp,life_b{1}{1}{1},'-rx','LineWidth',2);
    hold on;
    
    plot(temp,life_p{2}{1}{1},'--bx','LineWidth',2);
    hold on;
    plot(temp,life_b{2}{1}{1},'--rx','LineWidth',2);
    
    xlabel('Temperature (K)');
    ylabel('Lifetime (ns)');
    xlim([240, 270]);
    ax.XTick = 240:5:270;
    ax.XRuler.MinorTick = 'off';
    ax.YRuler.MinorTick = 'on';
    ax.YRuler.MinorTickValues = [0:2:120];
    title('Layer 1');
    legend('Prism Surface 1', 'Basal Surface 1','Prism Surface 2', 'Basal Surface 2','Location','NorthWest');
    
    subplot(2,2,2)
    ax = gca;
    plot(temp,life_p{1}{1}{2},'-bx','LineWidth',2);
    hold on;
    plot(temp,life_b{1}{1}{2},'-rx','LineWidth',2);
    hold on;
    plot(temp,life_p{2}{1}{2},'--bx','LineWidth',2);
    hold on;
    plot(temp,life_b{2}{1}{2},'--rx','LineWidth',2);
    
    xlabel('Temperature (K)');
    ylabel('Lifetime (ns)');
    xlim([240, 270]);
    ax.XTick = 240:5:270;
    ax.XRuler.MinorTick = 'off';
    ylim([0, 120]);
    ax.YTick = 0:10:120;
    ax.YRuler.MinorTick = 'on';
    ax.YRuler.MinorTickValues = [0:2:120];
    title('Layer 2');
    
    
    subplot(2,2,3)
    ax = gca;
    plot(temp,life_p{1}{1}{3},'-bx','LineWidth',2);
    hold on;
    plot(temp,life_b{1}{1}{3},'-rx','LineWidth',2);
    hold on;
    
    plot(temp,life_p{2}{1}{3},'--bx','LineWidth',2);
    hold on;
    plot(temp,life_b{2}{1}{3},'--rx','LineWidth',2);
    
    xlabel('Temperature (K)');
    ylabel('Lifetime (ns)');
    xlim([240, 270]);
    ax.XTick = 240:5:270;
    ax.XRuler.MinorTick = 'off';
    ax.YRuler.MinorTick = 'on';
    ax.YRuler.MinorTickValues = [0:2:120];
    title('Layer 3');
    
    
    subplot(2,2,4)
    ax = gca;
    plot(temp,life_p{1}{1}{4},'-bx','LineWidth',2);
    hold on;
    plot(temp,life_b{1}{1}{4},'-rx','LineWidth',2);
    hold on;
    
    plot(temp,life_p{2}{1}{4},'--bx','LineWidth',2);
    hold on;
    plot(temp,life_b{2}{1}{4},'--rx','LineWidth',2);
    
    xlabel('Temperature (K)');
    ylabel('Lifetime (ns)');
    xlim([240, 270]);
    ax.XTick = 240:5:270;
    ax.XRuler.MinorTick = 'off';
    ax.YRuler.MinorTick = 'on';
    ax.YRuler.MinorTickValues = [0:2:120];
    title('Layer 4');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Layer Population %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Plot population of layers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for t=1:num_temps;
    for l=1:5
        layerpop_temp_p(t,l) = LayerPop_p{t}(l);
        layerpop_temp_b(t,l) = LayerPop_b{t}(l);
    end
end

%%   Prism and Basal:Layer Population v. temp for boundaries 1 to 5 %%%%%%%
figure;
subplot(1,2,1)
for jj=1:5
    ax = gca;
    plot(temp,layerpop_temp_p(:,jj),'-x','LineWidth',2);
    hold on;
    xlabel('Temperature (K)');
    ylabel('Layer Population');
    xlim([240, 270]);
    ax.XTick = 240:5:270;
    ax.XRuler.MinorTick = 'off';
    ax.YRuler.MinorTick = 'on';
    ax.TickLength = [0.03 0.045];
    ax.FontSize = 14;
    ax.YLabel.FontSize = 18;
    ax.XLabel.FontSize = 18;
    ax.LineWidth = 1.5;
    ax.FontWeight = 'bold';
    legend('L1', 'L2', 'L3', 'L4', 'L5', 'Location','NorthWest');
end
subplot(1,2,2)
for jj=1:5
    ax = gca;
    plot(temp,layerpop_temp_b(:,jj),'--+','LineWidth',2);
    hold on;
    xlabel('Temperature (K)');
    ylabel('Layer Population');
    xlim([240, 270]);
    ax.XTick = 240:5:270;
    ax.XRuler.MinorTick = 'off';
    ax.YRuler.MinorTick = 'on';
    ax.TickLength = [0.03 0.045];
    ax.FontSize = 14;
    ax.YLabel.FontSize = 18;
    ax.XLabel.FontSize = 18;
    ax.LineWidth = 1.5;
    ax.FontWeight = 'bold';
end
title('Basal');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Plot population of layers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
subplot(1,2,1)
ax = gca;
for t=1:num_temps;
    plot(LayerPop_p{t},'-x','LineWidth',2);
    hold on;
end
xlabel('Boundary Coordinate (\AA)', 'interpreter','latex');
ylabel('Layer Population');
ylim([0, 300]);
title('Prism');
legend(temp_string,'Location','NorthEast');

subplot(1,2,2)
ax = gca;
for t=1:num_temps;
    plot(LayerPop_b{t},'-x','LineWidth',2);
    hold on;
end
xlabel('Boundary Coordinate (\AA)', 'interpreter','latex');
ylabel('Layer Population');
ylim([0, 300]);
title('Basal');
legend(temp_string,'Location','NorthEast');

end

