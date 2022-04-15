clc;
close all;
clear;
currentFolder = pwd;
addpath(genpath(currentFolder));
resultdir = './';
datadir='./';
% dataname={'MSRCV1', 'ORL', '20newsgroups','COIL20-3v', 'handwritten', ...
%     '100leaves', 'yale_mtv_2', 'Wikipedia'};
% dataname={'MSRCV1_3v', 'handwritten_3v', 'Wiki', 'scene-15'};
dataname={'Mnist_5K', 'ALOI_50'};
n_dataset = length(dataname); % number of the datasets
% for idata = 1:n_dataset-(n_dataset-1)
for idata = 1:2
    % read dataset
    dataset_file = [datadir, cell2mat(dataname(idata)),'.mat'];
    load(dataset_file);
    V = length(X); % the number of views
    oriData = cell(V,1);
    oriTruelabel = cell(V,1);
    for v = 1:V
        oriData{v} = X{v}';
        oriTruelabel{v} = Y;
    end
    clear X gt;
    N = size(oriData{1},2); % the number of instances
    n_view = length(oriData);
    perGrid = [1:-0.1:0]; %  the percentage of paired instances
    misingExampleVector = randperm(N);
    MissingStatus = zeros(N, n_view); % indicate the missing status of instance in each view
    for id = 1:N
        missingViewVector = randi([0, 1], n_view, 1, 'int8');
        while(0 == sum(missingViewVector) || n_view == sum(missingViewVector))
            % in case of all views mising
            missingViewVector = randi([0,1], n_view,1, 'int8');
        end
        MissingStatus(id, :) = missingViewVector;
    end
    for per_iter = 1:length(perGrid)
        per = perGrid(per_iter); % partial example ratio
        miss_n = fix((1-per)*N); % the number of missing instances
        perMisingExampleVector = misingExampleVector(1: miss_n);
        data = oriData;
        full_index = cell(1,n_view);
        for v = 1:n_view
            full_index{v} = zeros(N,1);
        end
        for id = 1: miss_n
            for j = 1 : n_view
                if 0 == MissingStatus(misingExampleVector(id), j)
                    data{j}(:,misingExampleVector(id)) = nan;
                    full_index{j}(misingExampleVector(id)) = 1;
                end
            end
        end
        index = cell(1, n_view);
        for v = 1:n_view
            index{v} = find(full_index{v}==0);
        end
        truelabel = oriTruelabel;
        save([resultdir,char(dataname(idata)),'_Per',num2str(per),'.mat'],'data','truelabel','index','MissingStatus');
        clear data truelabel index;
    end
end
