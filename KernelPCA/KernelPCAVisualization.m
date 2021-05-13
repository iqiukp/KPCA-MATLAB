classdef KernelPCAVisualization < handle
    %{
        CLASS DESCRIPTION

        Visualization of trained KPCA model and test results.
    
    -----------------------------------------------------------------
    
        Version 1.1, 14-MAY-2021
        Email: iqiukp@outlook.com
    -----------------------------------------------------------------
    %}
    
    properties (Constant)
        positionForOne = [300 150 600 300]
        positionForTwo = [300 150 800 600]
        colorStatistics = [125, 45, 141]/255
        colorLimit = [213, 81, 36]/255
        colorFace = [213, 81, 36]/255
        colorScatter =  [0, 114, 189;162, 20, 47]/255;
        colorContribution = [162, 20, 47]/255
        lineWidthStatistics = 2
        lineWidthBox = 1.1
        scatterSize = 36
        tickDirection = 'in'
    end
    
    methods
        function cumContribution(obj, kpca)
            dims_ = find(kpca.cumContribution > 0.99, 1, 'first');
            cumContribution_ = kpca.cumContribution(1:dims_)*100;
            figure
            set(gcf, 'position', obj.positionForOne)
            hold on
            plot(cumContribution_,...
                'color', obj.colorContribution,...
                'LineStyle', '-', 'LineWidth', obj.lineWidthStatistics)
            xlim([1, length(cumContribution_)]);
            ylim([cumContribution_(1), 100])
            posi = [kpca.numComponents, cumContribution_(kpca.numComponents)];
            % connected line
            line([posi(1, 1), posi(1, 1)], [cumContribution_(1), posi(1, 2)],...
                'color', 'k', 'LineStyle', '--', 'LineWidth', obj.lineWidthBox);
            line([1, posi(1, 1)], [posi(1, 2), posi(1, 2)],...
                'color', 'k', 'LineStyle', '--', 'LineWidth', obj.lineWidthBox);
            %
            plot(posi(1, 1), posi(1, 2),...
                'Marker', 'o',...
                'MarkerSize', 8,...
                'MarkerEdgeColor', obj.colorContribution,...
                'MarkerFaceColor', obj.colorContribution);
            
            testStr = ['(', num2str(posi(1, 1)), ', ', num2str(posi(1, 2)), '%)'];
            text(posi(1, 1)*1.1, posi(1, 2)*0.95, testStr, 'FontWeight', 'bold')
            ytickformat('%d%%')
            xlabel('Component number')
            ylabel('Cumulative contributions')
            set(gca, 'LineWidth', obj.lineWidthBox, 'TickDir', obj.tickDirection)
            box(gca, 'on');
        end
        
        function trainResults(obj, kpca)
            figure
            set(gcf, 'position', obj.positionForTwo)
            subplot(2, 1, 1)
            plot(kpca.SPELimit*ones(kpca.numSamples, 1),...
                'color', obj.colorLimit,...
                'LineStyle', '-',....
                'LineWidth', obj.lineWidthStatistics)
            hold on
            plot(kpca.SPE,...
                'color', obj.colorStatistics,...
                'LineStyle', '-',....
                'LineWidth', obj.lineWidthStatistics)
            legend({'SPE limit', 'SPE'})
            xlabel('Samples')
            ylabel('SPE')
            set(gca, 'LineWidth', obj.lineWidthBox,...
                'TickDir', obj.tickDirection, 'yscale','log')
            box(gca, 'on');
            
            subplot(2, 1, 2)
            plot(kpca.T2Limit*ones(kpca.numSamples, 1),...
                'color', obj.colorLimit,...
                'LineStyle', '-',....
                'LineWidth', obj.lineWidthStatistics)
            hold on
            plot(kpca.T2,...
                'color', obj.colorStatistics,...
                'LineStyle', '-',....
                'LineWidth', obj.lineWidthStatistics)
            legend({'T2 limit','T2'})
            xlabel('Samples')
            ylabel('T2')
            set(gca, 'LineWidth', obj.lineWidthBox,...
                'TickDir', obj.tickDirection, 'yscale','log')
            box(gca, 'on');
        end
        
        function testResults(obj, kpca, results)
            figure
            set(gcf, 'position', obj.positionForTwo)
            subplot(2, 1, 1)
            plot(kpca.SPELimit*ones(results.numSamples, 1),...
                'color', obj.colorLimit,...
                'LineStyle', '-',....
                'LineWidth', obj.lineWidthStatistics)
            hold on
            plot(results.SPE,...
                'color', obj.colorStatistics,...
                'LineStyle', '-',....
                'LineWidth', obj.lineWidthStatistics)
            legend({'SPE limit','SPE'})
            xlabel('Samples')
            ylabel('SPE')
            set(gca, 'LineWidth', obj.lineWidthBox,...
                'TickDir', obj.tickDirection, 'yscale','log')
            box(gca, 'on');
            
            subplot(2, 1, 2)
            plot(kpca.T2Limit*ones(results.numSamples, 1),...
                'color', obj.colorLimit,...
                'LineStyle', '-',....
                'LineWidth', obj.lineWidthStatistics)
            hold on
            plot(results.T2,...
                'color', obj.colorStatistics,...
                'LineStyle', '-',....
                'LineWidth', obj.lineWidthStatistics)
            legend({'T2 limit','T2'})
            xlabel('Samples')
            ylabel('T2')
            set(gca, 'LineWidth', obj.lineWidthBox,...
                'TickDir', obj.tickDirection, 'yscale','log')
            box(gca, 'on');
        end
        
        function score(obj, kpca)
            if kpca.numFeatures < 2 || kpca.numFeatures > 3 ...
                    || kpca.numComponents < 2 || kpca.numComponents > 3
                error('This demonstration only supports visualization of 2D or 3D data.')
            end
            for i = 1:3
                colormap_(:, i) = linspace(obj.colorScatter(1,i),obj.colorScatter(2,i),kpca.numSamples);
            end
            
            % original data
            figure
            set(gcf, 'position', obj.positionForOne)
            subplot(1, 2, 1)
            switch kpca.numFeatures
                case 2
                    scatter(kpca.data(:, 1), kpca.data(:, 2),...
                        obj.scatterSize, colormap_, 'filled')
                    
                case 3
                    scatter3(kpca.data(:, 1), kpca.data(:, 2), kpca.data(:, 3),...
                        obj.scatterSize, colormap_, 'filled')
            end
            colormap(gca, 'parula')
            set(gca, 'LineWidth', obj.lineWidthBox, 'TickDir', obj.tickDirection)
            box(gca, 'on');
            title('Original data')
            
            % scores
            subplot(1, 2, 2)
            switch kpca.numComponents
                case 2
                    scatter(kpca.score(:, 1), kpca.score(:, 2),...
                        obj.scatterSize, colormap_, 'filled')
                    
                case 3
                    scatter3(kpca.score(:, 1), kpca.score(:, 2), kpca.score(:, 3),...
                        obj.scatterSize, colormap_, 'filled')
            end
            set(gca, 'LineWidth', obj.lineWidthBox, 'TickDir', obj.tickDirection)
            box(gca, 'on');
            title('Mapping data');
        end
        
        function reconstruction(obj, kpca)
            if kpca.numFeatures < 2 || kpca.numFeatures > 3 ...
                    || kpca.numComponents < 2 || kpca.numComponents > 3
                error('This demonstration only supports visualization of 2D or 3D data.')
            end
            
            for i = 1:3
                colormap_(:, i) = linspace(obj.colorScatter(1,i),obj.colorScatter(2,i),kpca.numSamples);
            end
            
            % original data
            figure
            set(gcf, 'position', obj.positionForOne)
            subplot(1, 2, 1)
            switch kpca.numFeatures
                case 2
                    scatter(kpca.data(:, 1), kpca.data(:, 2),...
                        obj.scatterSize, colormap_, 'filled')
                    
                case 3
                    scatter3(kpca.data(:, 1), kpca.data(:, 2), kpca.data(:, 3),...
                        obj.scatterSize, colormap_, 'filled')
            end
            set(gca, 'LineWidth', obj.lineWidthBox, 'TickDir', obj.tickDirection)
            box(gca, 'on');
            title('Original data')
            
            subplot(1, 2, 2)
            switch kpca.numFeatures
                case 2
                    scatter(kpca.newData(:, 1), kpca.newData(:, 2),...
                        obj.scatterSize, colormap_, 'filled')
                    
                case 3
                    scatter3(kpca.newData(:, 1), kpca.newData(:, 2), kpca.newData(:, 3),...
                        obj.scatterSize, colormap_, 'filled')
            end
            set(gca, 'LineWidth', obj.lineWidthBox, 'TickDir', obj.tickDirection)
            box(gca, 'on');
            title('Reconstructed data');
        end
        
        function diagnosis(obj, results)
            figure
            set(gcf,'position', obj.positionForTwo)
            subplot(2, 1, 1)
            bar(results.diagnosis.meanSPECps,...
                'FaceColor', obj.colorFace,...
                'EdgeColor', 'k',...
                'LineWidth', obj.lineWidthStatistics);
            xlabel('Variables')
            ylabel('SPE contributions')
            set(gca, 'LineWidth', obj.lineWidthBox, 'TickDir', obj.tickDirection)
            titleStr = ['Sampling points between ', num2str(results.diagnosis.start),...
                ' and ', num2str(results.diagnosis.end)];
            title(titleStr)
            
            subplot(2, 1, 2)
            bar(results.diagnosis.meanT2Cps,...
                'FaceColor', obj.colorFace,...
                'EdgeColor', 'k',...
                'LineWidth', obj.lineWidthStatistics);
            xlabel('Variables')
            ylabel('T2 contributions')
            set(gca, 'LineWidth', obj.lineWidthBox, 'TickDir', obj.tickDirection)
            title(titleStr)
        end
    end
end