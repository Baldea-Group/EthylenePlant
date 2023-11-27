% This file is for simulating and plotting each model under operation

global Trxt_spchange_boolean Tves_spchange_boolean F0_feedchange_boolean
global X0_feedchange_boolean Xliq_spchange_boolean puritycontroller_boolean

figtitles = ["Rxt Holdup" "Rxt Feed Wt%" "Rxt Product Wt%" "Rxt H2 Wt%" "Rxt Temp" ...
            "Vessel Holdup" "Vessel Feed Wt%" "Vessel Product Wt%" "Vessel H2 Wt%" "Vessel Temp." ...
            "Vapor Holdup" "Vapor Feed Wt%" "Vapor Product Wt%" "Vapor H2 Wt%" "Vapor Temp" ...
            "Liquid Holdup" "Liquid Feed Wt%" "Liquid Product Wt%" "Liquid H2 Wt%" "Liquid Temp"];

yaxislabel = ["Holdup (kg)" "Weight Fraction" "Weight Fraction" "Weight Fraction" "Temperature (oC)" ...
              "Holdup (kg)" "Weight Fraction" "Weight Fraction" "Weight Fraction" "Temperature (oC)" ...
              "Holdup (kg)" "Weight Fraction" "Weight Fraction" "Weight Fraction" "Temperature (oC)" ...
              "Holdup (kg)" "Weight Fraction" "Weight Fraction" "Weight Fraction" "Temperature (oC)" ];

%% Switch true / false to test each scenario or turn on purity controller
 
Trxt_spchange_boolean = true;
Tves_spchange_boolean = false;
F0_feedchange_boolean = false;
X0_feedchange_boolean = false;
Xliq_spchange_boolean = false;
puritycontroller_boolean = true;

%% Simulate integrated model using Simulink and s-function

out=sim('integratedmodel_sml');

t_inte=out.tout/3600;
integrated = out.integrated;

z_ecc_ss = integrated(length(t_inte),:);

%% Simulate electric model using Simulink and s-function

out=sim('electricmodel_sml');

t_elec=out.tout/3600;
electric = out.electric;

ze_elec_ss = electric(length(t_elec),:);

%% Plot each states

figure(1)
for ind=1:1:20 %% State Variables
    subplot(4,5,ind);
    plot(t_inte,integrated(:,ind),'b','LineWidth',1);
    hold on
    plot(t_elec,electric(:,ind),'r','LineWidth',0.8)
    hold off
    title(figtitles(ind),'FontSize',8)
    ylabel(yaxislabel(ind),'FontSize',8)
    xlabel("Time (hr)",'FontSize',8)
    xlim([-0.5 t_elec(length(t_elec))]);
end

%% Plot Reactor Temperature

figure(5)
plot(t_inte,integrated(:,5),'b-','LineWidth',1)
hold on
plot(t_elec,electric(:,5),'r-','LineWidth',0.8);
hold off
title('Reactor Temperature')
legend('Integrated','Electric')
xlabel('Time (hr)')
ylabel('Temperature (C)')


%% Plot LHV

figure(29)
plot(t_inte,integrated(:,29),'b-','LineWidth',1)
hold on
plot(t_elec,electric(:,29),'r-','LineWidth',0.8);
hold off
title('LHV')
legend('Integrated','Electrified')
xlabel('Time (hr)')
ylabel('LHV (kJ/kg)')


%% Plot Energy Consumption

figure(28)
plot(t_inte,integrated(:,28),'b-','LineWidth',1);
hold on
plot(t_inte,integrated(:,28)-integrated(:,31),'b:','LineWidth',1.3);
hold on
plot(t_inte,integrated(:,31),'g:','LineWidth',1.3); % Natural Gas
hold on
plot(t_elec,electric(:,28),'r:','LineWidth',1);
hold off
title('Energy Consumption')
legend('Total Combustion','Fuel Gas Combustion','Natural Gas Combustion','Electric Heating')
xlabel('Time (hr)')
ylabel('Heat (kW) ')


%% Plot Liquid Product Composition

figure(18)
plot(t_inte,integrated(:,18),'b-','LineWidth',1);
hold on
plot(t_elec,electric(:,18),'r-','LineWidth',1);
hold off
title('Liquid Product Composition')
legend('Integrated','Electric')
xlabel('Time (hr)')
ylabel('Composition ')

%% Plot LHV and Fuel Gas Stream

figure(65)
yyaxis left
plot(t_inte,integrated(:,29),'b-','LineWidth',1) % LHV
ylabel('kJ/kg')
yyaxis right
plot(t_inte,integrated(:,34),'g-','LineWidth',1);
ylabel('kg/s')
title('LHV vs Fuel Gas Stream Fr')
legend('LHV','Fr_comb');
xlabel('Time (hr)')
xlim([-0.5 t_inte(length(t_inte))]);

%% Heat input vs supply, all at once
%{
figure(24)
plot(t_inte,integrated(:,21),'b-','LineWidth',1);
hold on
plot(t_inte,integrated(:,28),'b:','LineWidth',1);
hold on
plot(t_elec,electric(:,21),'r-','LineWidth',0.8);
hold on
plot(t_elec,electric(:,28),'r:','LineWidth',0.8);
hold off
xlabel('Time (hr)')
ylabel('Heat supplied (kW)')
legend('Actual Heat Input','Combusted Heat','Actual Heat Input','Electric Heat')
%}