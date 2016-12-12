function [ ] = LayerRemain_Plot(temp, num_temps, temp_string, n_remain_p, n_remain_b, frame_p, frame_b, half_frame_p, half_frame_b, kappa_p, kappa_b, kappafit_p, kappafit_b)
% Function plots number of mols. remainign analysis. 
% Plots include the # mols vs time. Decays to 0 as don't take into account
% molecules even if they return

for t=1:num_temps
    figure;
    subplot(2,1,1)
    plot(frame_p{t},n_remain_p{t}{1},'-b','LineWidth',2.0);
    hold on;
    plot(frame_p{t},n_remain_p{t}{2},'-c','LineWidth',2.0);
    hold on;
    
    plot(frame_b{t},n_remain_b{t}{1},'-r','LineWidth',2.0);
    hold on;
    plot(frame_b{t},n_remain_b{t}{2},'-m','LineWidth',2.0);
    title(temp_string(t));
    xlabel('Time (ns)');
    ylabel('Fraction remaining');
    legend('Prism Bottom', 'Prism Top', 'Basal Bottom', 'Basal Top');
    title(temp_string{t});
    
    subplot(2,1,2)
    plot(frame_p{t},log(n_remain_p{t}{1}),'-b','LineWidth',2.0);
    hold on;
    plot(kappafit_p{t},'-k');
    hold on;
    plot(frame_b{t},log(n_remain_b{t}{1}),'-r','LineWidth',2.0);
    hold on;
    plot(kappafit_b{t},'-k');
    hold on;
end


tmp_temp = 1./temp(1:6);
tmp_kappa_p = log(kappa_p(1:6));
tmp_kappa_b = log(kappa_b(1:6));
[f_p, error, out] = fit(tmp_temp',tmp_kappa_p','poly1');
[f_b, error, out] = fit(tmp_temp',tmp_kappa_b','poly1');    
energy_p = f_p.p1/8.3144598
energy_b = f_b.p1/8.3144598

figure; 
subplot(1,3,1)
plot(temp,kappa_b,'-r*');
hold on;
plot(temp,kappa_p,'-b*');
legend('Basal', 'Prism');
ylabel('\kappa'); 
xlabel('T (K)'); 

subplot(1,3,2)
plot(1./temp,log(kappa_b),'-r*');
hold on;
plot(f_b,'-m');
hold on;
plot(1./temp,log(kappa_p),'-b*');
hold on;
plot(f_p,'-c');
ylabel('ln(\kappa)'); 
xlabel('1/T (1/K)'); 

subplot(1,3,3)
plot(temp,1./kappa_b,'-r*');
hold on;
plot(temp,1./kappa_p,'-b*');
ylabel('\tau (ns)');
xlabel('T (K)');


for surf=1:2
    for t=1:num_temps
        half_step_p{surf}(t) = frame_p{t}(half_frame_p{t}(surf));
        half_step_b{surf}(t) = frame_b{t}(half_frame_b{t}(surf));
    end
end

half_step_p{1}

figure;
plot(temp,half_step_p{1},'-b*');
hold on;
plot(temp,half_step_p{2},'-c*');
hold on;

plot(temp,half_step_b{1},'-r*');
hold on;
plot(temp,half_step_b{2},'-m*');
xlabel('Temperature (K)');
ylabel('Half-life of surface molcules (ns)');
legend('Prism Bottom', 'Prism Top', 'Basal Bottom', 'Basal Top');

