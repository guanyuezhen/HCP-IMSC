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

dataname = {'ORL'};
numdata = length(dataname);
nummethod = length(datadir);

for idata = 1:numdata
    acc = zeros(9,nummethod);
    nmi = zeros(9,nummethod);
    purity = zeros(9,nummethod);
    Fscore = zeros(9,nummethod);
    Precision = zeros(9,nummethod);
    Recall = zeros(9,nummethod);
    AR = zeros(9,nummethod);
    for imethod = 1:nummethod
        res = cell(nummethod, 1);
        datafile = [char(datadir(imethod)), char(dataname(idata)), '_result.mat'];
        load(datafile);
        fprintf('%s...\n', datafile);
        % result = [Fscore Precision Recall nmi AR Entropy ACC Purity];
        % acc
        acc(:,imethod) = ResBest(:,7);
        % nmi
        nmi(:,imethod) = ResBest(:,4);
        % purity
        purity(:,imethod) = ResBest(:,8);
        % Fscore
        Fscore(:,imethod) = ResBest(:,1);
        Precision(:,imethod) = ResBest(:,2);
        Recall(:,imethod) = ResBest(:,3);
        AR(:,imethod) = ResBest(:,5); 
    end
    
%     save result1 acc nmi purity
    save([resultdir1 char(dataname(idata)), '.mat'], 'acc', 'nmi', 'purity', 'Fscore', ...
        'Precision', 'Recall', 'AR');
end
