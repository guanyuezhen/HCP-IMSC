clear all
clc
if (~exist('Results', 'file'))
    mkdir('allResults');
    addpath(genpath('allResults/'));
end
resultdir1 = 'allResults/';
datadir = {'./BSV/', './MIC/', './MKKM-IK/', './MKKM-IK-MKC/', './UEAF/',...
    './FLSD/', './EE-R-IMVC/', './AWP/', './APMC/', './PIC/', ...
    './V3H/', './Ours/'};
 
dataname = {'3sourceIncomplete', 'bbcsportIncomplete', 'bbcIncomplete'};
numdata = length(dataname);
nummethod = length(datadir);

for idata = 1:numdata - 2
    res = zeros(nummethod, 8);
    for imethod = 1:nummethod
        datafile = [char(datadir(imethod)), char(dataname(idata)), '_result.mat'];
        load(datafile);
        fprintf('%s...\n', datafile);
        res(imethod, : ) = ResBest;
        for temp = 1:8
            result(imethod, temp) = string([num2str(ResBest(1,temp),'%.4f'), '$\pm$' ,num2str(ResStd(1,temp),'%.4f')]);
        end
    end
    [B, I] = sort(res, 'descend');
    for temp = 1:8
        result( I(1, temp ),  temp) = string(['\textbf{', char(result( I(1, temp ), temp)) , '}']);
        result( I(2, temp ),  temp ) = string(['{\ul', char(result( I(2, temp ), temp)) , '}']);
    end
    result(:, 6 ) = [];
    save([resultdir1 char(dataname(idata)), '.mat'], 'result');
    clear result;
end
