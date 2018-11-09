% DESCRIPTION
% Plot the results
%
%    [D] = SVDD_TEST(MODEL,Y)
%
% INPUT
%   R         Threshold
%   Y         Distance
%
% Created on 1st November, 2018, by Kepeng Qiu.

function plotResult(R,D)

%
figure
plot(R*ones(size(D,1),1),'k-','Linewidth',1,'MarkerSize',10,'MarkerEdgeColor','k', 'MarkerFaceColor','k')
hold on
plot(D,'b-o','Linewidth',1,'MarkerSize',4,'MarkerEdgeColor','b', 'MarkerFaceColor','g')

% Axis settings

tgca = 16;  % font size
tfont = 'Helvetica'; % font type
% tfont = 'Arial'; % font type
% set(gca,'yscale','log')
set(gca,'FontSize',tgca,'FontName',tfont)

% legend settings
tlegend = tgca*0.9;
legend({'Threshold','Distance'},'FontSize',tlegend ,'FontWeight','normal','FontName',tfont)

% label settings
tlabel = tgca*1.1; 
xlabel('Sample','FontSize',tlabel,'FontWeight','normal','FontName',tfont,'Color','k')
ylabel('Statistic','FontSize',tlabel,'FontWeight','normal','FontName',tfont,'Color','k')

end
