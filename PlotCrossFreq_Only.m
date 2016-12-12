function [ ] = PlotCrossFreq_Only(rate_interface_q3_b, std_interface_q3_b, rate_interface_q3_p, std_interface_q3_p, ...
    rate_interface_E_b, std_interface_E_b, rate_interface_E_p, std_interface_E_p, ...
    rate_interface_q3_bothsurf_b, std_interface_q3_bothsurf_b, rate_interface_q3_bothsurf_p, std_interface_q3_bothsurf_p, ...
    rate_interface_E_bothsurf_b, std_interface_E_bothsurf_b, rate_interface_E_bothsurf_p, std_interface_E_bothsurf_p)

% Plots crossing analysis. Plots include rate of crossing calculated 
% from interface determined using q3 and free energy of diffusion 


num_temps = 7;
temp = [240 245 250 255 260 265 270];
  
    
%% Plot rate crossing q3     
figure;
    for dir=1:2
        subplot(1,2,dir)
        ax = gca;
        errorbar(temp,rate_interface_q3_p{1}{dir},std_interface_q3_p{1}{dir},'-bx','LineWidth',2);
        hold on;
        errorbar(temp,rate_interface_q3_b{1}{dir},std_interface_q3_b{1}{dir},'-r*','LineWidth',2);
        hold on;

        errorbar(temp,rate_interface_q3_p{2}{dir},std_interface_q3_p{2}{dir},'--cx','LineWidth',2);
        hold on;
        errorbar(temp,rate_interface_q3_b{2}{dir},std_interface_q3_b{2}{dir},'--m*','LineWidth',2);
        title('q3');
        xlabel('Temperature (K)');
        if dir == 1
            ylabel('Crossing Frequency Into Bulk (1/ns)');
        elseif dir == 2
            ylabel('Crossing Frequency Out of Bulk (1/ns)');
        end
        xlim([235, 275]);
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
        if dir == 1
            legend('Prism Surface 1', 'Basal Surface 1','Prism Surface 2', 'Basal Surface 2','Location','NorthWest'); 
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Plot rate crossing E     
figure;
    for dir=1:2
        subplot(1,2,dir)
        ax = gca;
        errorbar(temp,rate_interface_E_p{1}{dir},std_interface_E_p{1}{dir},'-bx','LineWidth',2);
        hold on;
        errorbar(temp,rate_interface_E_b{1}{dir},std_interface_E_b{1}{dir},'-r*','LineWidth',2);
        hold on;

        errorbar(temp,rate_interface_E_p{2}{dir},std_interface_E_p{2}{dir},'--cx','LineWidth',2);
        hold on;
        errorbar(temp,rate_interface_E_b{2}{dir},std_interface_E_b{2}{dir},'--m*','LineWidth',2);
        title('Energy');
        xlabel('Temperature (K)');
        if dir == 1
            ylabel('Crossing Frequency Into Bulk (1/ns)');
        elseif dir == 2
            ylabel('Crossing Frequency Out of Bulk (1/ns)');
        end
        xlim([235, 275]);
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
        if dir == 1
            legend('Prism Surface 1', 'Basal Surface 1','Prism Surface 2', 'Basal Surface 2','Location','NorthWest'); 
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Plot Average of both surfaces rate crossing q3
figure;
    for dir=1:2
        subplot(1,2,dir)
        ax = gca;
        errorbar(temp,rate_interface_q3_bothsurf_p{dir},std_interface_q3_bothsurf_p{dir},'-bx','LineWidth',2);
        hold on;
        errorbar(temp,rate_interface_q3_bothsurf_b{dir},std_interface_q3_bothsurf_b{dir},'-r*','LineWidth',2);
        title('q3 Average');
        xlabel('Temperature (K)');
        if dir == 1
            ylabel('Crossing Frequency Into Bulk (1/ns)');
        elseif dir == 2
            ylabel('Crossing Frequency Out of Bulk (1/ns)');
        end
        xlim([235, 275]);
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
        if dir == 1
            legend('Prism Surface Average', 'Basal Surface Average','Location','NorthWest'); 
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Plot Average of both surfaces rate crossing E
figure;
    for dir=1:2
        subplot(1,2,dir)
        ax = gca;
        errorbar(temp,rate_interface_E_bothsurf_p{dir},std_interface_E_bothsurf_p{dir},'-bx','LineWidth',2);
        hold on;
        errorbar(temp,rate_interface_E_bothsurf_b{dir},std_interface_E_bothsurf_b{dir},'-r*','LineWidth',2);
        title('E Average');
        xlabel('Temperature (K)');
        if dir == 1
            ylabel('Crossing Frequency Into Bulk (1/ns)');
        elseif dir == 2
            ylabel('Crossing Frequency Out of Bulk (1/ns)');
        end
        xlim([235, 275]);
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
        if dir == 1
            legend('Prism Surface Average', 'Basal Surface Average','Location','NorthWest'); 
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOTS FOR PAPER AND PRESENTATIONS:

for dir=1:2
        figure;
        ax = gca;
        errorbar(temp,rate_interface_q3_bothsurf_p{dir},std_interface_q3_bothsurf_p{dir},'-bx','LineWidth',2);
        hold on;
        errorbar(temp,rate_interface_q3_bothsurf_b{dir},std_interface_q3_bothsurf_b{dir},'-r*','LineWidth',2);
        xlabel('Temperature (K)');
        if dir == 1
            ylabel('Cross Frequency Into Bulk (1/ns)');
        elseif dir == 2
            ylabel('Cross Frequency Out of Bulk (1/ns)');
        end
        xlim([235, 275]);
        ax.XTick = 240:5:270;
        ax.XRuler.MinorTick = 'off';
        ylim([0, 40]);
        ax.YTick = 0:10:40;
        ax.YRuler.MinorTick = 'on';
        ax.YRuler.MinorTickValues = [0:2:40];
        ax.TickLength = [0.03 0.045];
        ax.FontSize = 14;
        ax.YLabel.FontSize = 18;
        ax.XLabel.FontSize = 18;
        ax.LineWidth = 1.5;
        ax.FontWeight = 'bold';
        legend('Prism (q3)', 'Basal (q3)','Location','NorthWest'); 
        
end



for dir=1:2
        figure;
        ax = gca;
        errorbar(temp,rate_interface_E_bothsurf_p{dir},std_interface_E_bothsurf_p{dir},'-bx','LineWidth',2);
        hold on;
        errorbar(temp,rate_interface_E_bothsurf_b{dir},std_interface_E_bothsurf_b{dir},'-r*','LineWidth',2);
        xlabel('Temperature (K)');
        if dir == 1
            ylabel('Cross Frequency Into Bulk (1/ns)');
        elseif dir == 2
            ylabel('Cross Frequency Out of Bulk (1/ns)');
        end
        xlim([235, 275]);
        ax.XTick = 240:5:270;
        ax.XRuler.MinorTick = 'off';
        ylim([0, 40]);
        ax.YTick = 0:10:40;
        ax.YRuler.MinorTick = 'on';
        ax.YRuler.MinorTickValues = [0:2:40];
        ax.TickLength = [0.03 0.045];
        ax.FontSize = 14;
        ax.YLabel.FontSize = 18;
        ax.XLabel.FontSize = 18;
        ax.LineWidth = 1.5;
        ax.FontWeight = 'bold';
        legend('Prism (1.0 kT)', 'Basal (1.0 kT)','Location','NorthWest'); 
    end