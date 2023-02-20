clear
clc
Color = [166, 206,227;
    31,120,180;
    178,223,138;
    51,160,44;
    251,154,153;
    227,26,28;
    253,191,111;
    255,127,0;
    202,178,214;
    106,61,154;
    177,89,40;
    255,0,0]./255;
dataname = {'ORL'};
numdata = length(dataname);
for idata = 1 : numdata
    datafile = ['./allResults/', char(dataname(idata)), '.mat'];
    load(datafile);
    
    figureUnits = 'centimeters';
    figureWidth = 12;
    figureHeight = 15;
    
    figureHandle = figure(1);
    set(gcf, 'Units', figureUnits, 'Position', [0 0 figureWidth figureHeight]);
    hold on
    
    t = 1 : 2 : 9;
    res = acc;
    plot(res(t, 1), '--p', 'Linewidth', 1.5, 'Markersize', 5, 'Color',Color(1,:));
    hold on
    plot(res(t, 2), '--o', 'Linewidth', 1.5, 'Markersize', 5, 'Color',Color(2,:));
    hold on
    plot(res(t, 3), '--x', 'Linewidth', 1.5, 'Markersize', 8, 'Color',Color(3,:));
    hold on
    plot(res(t, 4), '-.+', 'Linewidth', 1.5, 'Markersize', 8, 'Color',Color(4,:));
    hold on
    plot(res(t, 5), '-.*', 'Linewidth', 1.5, 'Markersize', 8, 'Color',Color(5,:));
    hold on
    plot(res(t, 6), '-.s', 'Linewidth', 1.5, 'Markersize', 8, 'Color',Color(6,:));
    hold on
    plot(res(t, 7), ':d', 'Linewidth', 1.5, 'Markersize', 8, 'Color',Color(7,:));
    hold on
    plot(res(t, 8), ':v', 'Linewidth', 1.5, 'Markersize', 8, 'Color',Color(8,:));
    hold on
    plot(res(t, 9), ':^', 'Linewidth', 1.5, 'Markersize', 8, 'Color',Color(9,:));
    hold on
    plot(res(t, 10), '-<', 'Linewidth', 1.5, 'Markersize', 8, 'Color',Color(10,:));
    hold on
    plot(res(t, 11), '->', 'Linewidth', 1.5, 'Markersize', 8, 'Color',Color(11,:));
    hold on
    plot(res(t, 12), '-h', 'Linewidth', 2, 'Markersize', 8, 'Color',Color(12,:));
    hold off
    xlabel('Paired Ratio', 'FontName', 'Helvetica', 'FontSize', 18);
    ylabel('ACC', 'FontName', 'Helvetica', 'FontSize', 18);
    set(gca, 'XTickLabel', {'0.1', '0.3', '0.5', '0.7', '0.9'}, ...
        'FontName', 'Helvetica', 'FontSize', 14);
    set(gca, 'Box', 'on', ...
        'XGrid', 'on', 'YGrid', 'on', ...
        'TickDir', 'in', 'TickLength', [.01 .01], ...
        'XMinorTick', 'off', 'YMinorTick', 'on', ...
        'XColor', [.1 .1 .1],  'YColor', [.1 .1 .1],...
        'XTick', [1 : 5])
    set(gca,'Color',[1 1 1]);
    legend({'BSV', 'MIC', 'MKKM-IK', 'MKKM-IK-MKC', 'UEAF',...
    'FLSD', 'EE-R-IMVC', 'AWP', 'APMC', 'PIC', ...
    'V3H', 'Ours'}, ...
        'Location', 'southeast', 'FontName', 'Helvetica', 'FontSize', 10);
    
    figW = figureWidth;
    figH = figureHeight;
    set(figureHandle,'PaperUnits',figureUnits);
    set(figureHandle,'PaperPosition',[0 0 figW figH]);
    PicPath = ['Fig/' char(dataname(idata)), '_ACC', '.jpg'];
    print('-djpeg', '-r300', PicPath);
end