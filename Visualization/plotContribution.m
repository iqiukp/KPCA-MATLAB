function plotContribution(contribution, type)
%{

DESCRIPTION
 Plot the Contribution

       plotContribution(contribution, type)

    INPUT
      contribution   contribution of T2 and SPE
      type           'T2' or 'SPE'

Created on 16th November 2019 by Kepeng Qiu.
-------------------------------------------------------------%

%}

    figure
    set(gcf,'unit', 'centimeters', 'position', [20 9 20 9]);
    
    switch type
        case 'SPE'
            data = contribution.specps;
        case 'T2'
            data = contribution.t2cps;
    end
    temp = mean(abs(data), 1);
    bar(temp/sum(temp, 2),...
        'FaceColor', [213, 81, 36]/255,...
        'EdgeColor', 'k',...
        'LineWidth', 1.5);

    % axis settings
    tgca = 12;  % font size
    set(gca,'FontSize',tgca)
    % label settings
    tlabel = tgca*1.1;

    xlabel( 'Variables',...
        'FontSize',tlabel,...
        'FontWeight','normal',...
        'Color','k')
    ylabel([type, ' contribution'],...
        'FontSize', tlabel,...
        'FontWeight', 'normal',...
        'Color','k')

    titlestr = ['Sampling points between ', num2str(contribution.startingtime),...
        ' and ', num2str(contribution.endingtime)];
    title(titlestr)
    
    box off
    ax = axes('Position',get(gca,'Position'),...
        'XAxisLocation','top',...
        'YAxisLocation','right',...
        'Color','none',...
        'XColor','k','YColor','k');
    set(ax, 'XTick', []);
    set(ax, 'YTick', []);
    box on
    set(gca, 'linewidth', 1.1)
end

