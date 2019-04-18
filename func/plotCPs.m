function plotCPs(CPs)
% DESCRIPTION
% Plot Contribution Plots
%
%    plotCPs(CPs)
%
% INPUT
%   CPs         Contribution Plots
%
% Created on 18th April 2019, by Kepeng Qiu.
%-------------------------------------------------------------%

%
figure
temp = mean(abs(CPs),1);
bar(temp/sum(temp,2));

% Axis settings
tgca = 16;  % font size
tfont = 'Helvetica'; % font type
% tfont = 'Arial'; % font type
% set(gca,'yscale','log')
set(gca,'FontSize',tgca,'FontName',tfont)

% legend settings
tlegend = tgca*0.9;
legend({'Contribution Plots'},'FontSize',tlegend , ... 
    'FontWeight','normal','FontName',tfont)

% label settings
tlabel = tgca*1.1; 
xlabel('Variable','FontSize',tlabel,'FontWeight','normal', ... 
    'FontName',tfont,'Color','k')
ylabel('CPs','FontSize',tlabel,'FontWeight','normal', ... 
    'FontName',tfont,'Color','k')

end
