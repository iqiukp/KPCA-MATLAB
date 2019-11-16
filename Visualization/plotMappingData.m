function plotMappingData(X, Y, varargin)
%{

DESCRIPTION
 Plot the mapping data (only support for 2D or 3D data)

       plotMappingData(X, Y, varargin)

    INPUT
      X           original data
      Y           mapping data

Created on 16th November 2019 by Kepeng Qiu.
-------------------------------------------------------------%

%}

    if nargin == 3
        label = varargin{1};
        labelflag = 1;
    else
        labelflag = 0;
    end
    if nargin < 2 || nargin > 3
        error('Please enter the correct number of parameters.')
    end

    [MX, NX] = size(X);
    [~, NY] = size(Y);

    if NX<2 || NX>3 || NY<2 || NY>3
        error('Only support for 2D or 3D data')
    end

    scattersize = 16;
    linewidth = 1.1;
    switch labelflag
        case 0
            scattercolormap = colormap(jet);
            close Figure 1
            colornumber = size(scattercolormap, 1);
            sequence = linspace(1, colornumber, MX);
            scattercolor = zeros(MX, 3);
            for i = 1:3
                scattercolor(:,i) = interp1(1:colornumber,...
                    scattercolormap(:,i), sequence', 'spline');
            end

            % plot
            figure
            set(gcf,'unit', 'centimeters', 'position', [20 9 20 9]);

            subplot(1, 2, 1)
            unlabelplot(NX, X, scattersize, scattercolor, linewidth);
            
            
            set(gca, 'linewidth', 1.1)

            subplot(1, 2, 2)
            unlabelplot(NY, Y, scattersize, scattercolor, linewidth);
            

        case 1
            [labeltype, ~, ~] = unique(label);
            labelnumber = size(labeltype, 1);
            figure
            set(gcf,'unit', 'centimeters', 'position', [20 9 20 9]);

            subplot(1, 2, 1)
            hold on
            labelplot(NX, X, label, labelnumber, labeltype, scattersize, linewidth)
            
            subplot(1, 2, 2)
            hold on
            labelplot(NY, Y, label, labelnumber, labeltype, scattersize, linewidth)
            

    end

        function unlabelplot(N, data, scattersize, scattercolor, linewidth)
        %{

        DESCRIPTION
         Plot the mappingdata for unlabel data

               unlabelplot(N, data, scattersize, scattercolor)
        -------------------------------------------------------------%

        %}
            if N == 2
                scatter(data(:, 1), data(:, 2), scattersize, scattercolor, 'filled')
                setSpines(get(gca,'Position'), linewidth);
            else
                scatter3(data(:, 1), data(:, 2), data(:, 3), scattersize, scattercolor, 'filled')
            end
        end


        function labelplot(N, data, label, labelnumber, labeltype, scattersize, linewidth)
        %{

        DESCRIPTION
         Plot the mappingdata for label data

              labelplot(N, data, label, labelnumber, labeltype, scattersize)
        -------------------------------------------------------------%

        %}
            if N == 2
                for i = 1:labelnumber
                    scatter(data(label == labeltype(i,1), 1),...
                        data(label == labeltype(i,1), 2), scattersize, 'filled')
                end
                setSpines(get(gca,'Position'), linewidth);
            else
                for i = 1:labelnumber
                    scatter(data(label == labeltype(i,1), 1),...
                        data(label == labeltype(i,1), 2),...
                        data(label == labeltype(i,1), 3), scattersize, 'filled')
                end
            end
        end
        
    function setSpines(obj, linewidth)
        box off
        ax = axes('Position', obj,...
            'XAxisLocation', 'top',...
            'YAxisLocation', 'right',...
            'Color', 'none',...
            'XColor', 'k', 'YColor', 'k');
        set(ax, 'XTick', []);
        set(ax, 'YTick', []);
        box on
        set(gca, 'linewidth', linewidth)
    end 
end

