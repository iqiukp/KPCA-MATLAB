classdef Visualization < handle
    
    methods(Static)
        
        function map(X, X_map, label)
            d = size(X, 2);
            if d<2 || d>3
                error('Only 2D data is supported for visualization.')
            end
            color = [254, 67, 101;0, 114, 189;27, 158, 119]/255;
            figure
            set(gcf,'position',[300 150 600 300])
            %             set(gcf,'position',[300 150 400 200])
            subplot(1, 2, 1)
            ax = gscatter(X(:,1), X(:,2), label, color, 'o', 5);
            set(ax(1), 'MarkerEdgeColor','k', 'MarkerFaceColor', color(1,:));
            set(ax(2), 'MarkerEdgeColor','k', 'MarkerFaceColor', color(2,:));
            legend('off')
            set(gca, 'linewidth', 1.1)
            title('Original data')
            
            subplot(1, 2, 2)
            ax = gscatter(X_map(:,1), X_map(:,2), label, color, 'o', 5);
            set(ax(1), 'MarkerEdgeColor','k', 'MarkerFaceColor', color(1,:));
            set(ax(2), 'MarkerEdgeColor','k', 'MarkerFaceColor', color(2,:));
            legend('off')
            set(gca, 'linewidth', 1.1)
            title('Mapping data')
        end
        
        function prediction(obj)
            figure
            set(gcf,'position',[300 150 800 600])
            %             set(gcf,'position',[300 150 400 300])
            subplot(2, 1, 1)
            plot(obj.model.speLimit*ones(obj.prediction.n_samples, 1),...
                'color', [213, 81, 36]/255,...
                'LineStyle', '-',....
                'LineWidth', 2)
            hold on
            plot(obj.prediction.spe,...
                'color', [125, 45, 141]/255,...
                'LineStyle', '-',....
                'LineWidth', 2)
            legend({'SPE limit','SPE'})
            xlabel('Samples')
            ylabel('SPE')
            set(gca, 'linewidth', 1.1)
            set(gca,'yscale','log')
            
            subplot(2, 1, 2)
            plot(obj.model.t2Limit*ones(obj.prediction.n_samples, 1),...
                'color', [213, 81, 36]/255,...
                'LineStyle', '-',....
                'LineWidth', 2)
            hold on
            plot(obj.prediction.t2,...
                'color', [125, 45, 141]/255,...
                'LineStyle', '-',....
                'LineWidth', 2)
            legend({'T2 limit','T2'})
            xlabel('Samples')
            ylabel('T2')
            set(gca, 'linewidth', 1.1)
            set(gca,'yscale','log')
        end
        
        function reconstruct(X, X_map, X_re, label)
            
            d = size(X, 2);
            if d<2 || d>3
                error('Only 2D data is supported for visualization.')
            end
            size_ = 3;
            
            tmp = tabulate(label);
            
            n_label = size(tmp, 1);
            
            color = [254, 67, 101;0, 114, 189;27, 158, 119]/255;
            figure
            set(gcf,'position',[300 150 900 300])
%             set(gcf,'position',[300 150 450 150])
            title_str = {'Original data', 'Mapping data (dim = 2)', 'Reconstructed data'};
            data = {X, X_map, X_re};
            for i = 1:3
                subplot(1, 3, i)
                ax = gscatter(data{i}(:,1), data{i}(:,2), label, color, 'o', size_);
                for j = 1:n_label
                    set(ax(j), 'MarkerEdgeColor','k', 'MarkerFaceColor', color(j,:));
                end
                legend('off')
                set(gca, 'linewidth', 1.1)
                title(title_str{i})
            end
        end
        
        function diagnose(obj)
            
            figure
            set(gcf,'position',[300 150 800 600])
%             set(gcf,'position',[300 150 400 300])
            subplot(2, 1, 1)
            tmp = mean(abs(obj.prediction.specps), 1);
            bar(tmp/sum(tmp, 2),...
                'FaceColor', [213, 81, 36]/255,...
                'EdgeColor', 'k',...
                'LineWidth', 1.5);
            xlabel('Variables')
            ylabel('SPE contribution')
            set(gca, 'linewidth', 1.1)
            titlestr = ['Sampling points between ', num2str(obj.prediction.start_time),...
                ' and ', num2str(obj.prediction.end_time)];
            title(titlestr)
            
            subplot(2, 1, 2)
            tmp = mean(abs(obj.prediction.t2cps), 1);
            bar(tmp/sum(tmp, 2),...
                'FaceColor', [213, 81, 36]/255,...
                'EdgeColor', 'k',...
                'LineWidth', 1.5);
            xlabel('Variables')
            ylabel('T2 contribution')
            set(gca, 'linewidth', 1.1)
            titlestr = ['Sampling points between ', num2str(obj.prediction.start_time),...
                ' and ', num2str(obj.prediction.end_time)];
            title(titlestr)
        end
        
    end
end

