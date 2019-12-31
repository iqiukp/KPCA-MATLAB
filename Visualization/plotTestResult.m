function plotTestResult(controllimit, statistic, type)
%{

DESCRIPTION
 Plot the testing results

      plotTestResult(controllimit, statistic, type)

    INPUT
      controllimit   control limit of T2 and SPE
      statistic      statistic of T2 and SPE
      type           'T2' or 'SPE'

Created on 16th November 2019 by Kepeng Qiu.
-------------------------------------------------------------%

%}

    %
    figure            
    set(gcf,'unit', 'centimeters', 'position', [20 9 20 9]);
    plot(controllimit*ones(size(statistic,1),1),...
        'color', [213, 81, 36]/255,...
        'LineStyle', '-',....
        'LineWidth', 2)
    hold on
    plot(statistic,...
        'color', [125, 45, 141]/255,...
        'LineStyle', '-',....
        'LineWidth', 2)

    % axis settings
    tgca = 12;  % font size

    if isempty(find(statistic<0, 1))
        set(gca,'yscale','log')
    end
    
    set(gca,'FontSize',tgca)
    
    % legend settings
    tlegend = tgca*0.9;
    legend({'Control limit','Statistic'}, ...
            'FontSize', tlegend , ...
            'FontWeight', 'normal')

    % label settings
    tlabel = tgca*1.1; 
    xlabel( 'Samples',...
            'FontSize',tlabel,...
            'FontWeight','normal',...
            'Color','k')
    ylabel([type, ' statistic'],...
            'FontSize', tlabel,...
            'FontWeight', 'normal',...
            'Color','k')
    % 
    set(gca, 'linewidth', 1.1)
end
