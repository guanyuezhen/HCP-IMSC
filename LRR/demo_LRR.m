%% For convinience, we assume the order of the tensor is always 3;
clear;
addpath('..\ClusteringMeasure');
addpath('..\Nuclear_norm_l21_Algorithm');
load('yale.mat');  % lambda = 10 bestComb:X3,X2
cls_num = length(unique(gt));

%data preparation...
 X{1} = X2; X{2} = X3; X{3} = X1;
 for v=1:3
    [X{v}]=NormalizeData(X{v});
     %X{v} = zscore(X{v},1);
end
% Initialize...
lambda = [0.1:0.4:5];
num = size(lambda, 2);
ACC = [];
for j = 1:num
    %[Z{1}, E{1}] = inexact_alm_lrr_l21(X{1}, X{1}, lambda(j), 1);
    [Z{1}, E{1}] = inexact_alm_lrr_l21(X{1}, X{1}, 1.5, 1);
    A = 0.5*(abs(Z{1})+abs(Z{1}'));
    C = SpectralClustering(A, cls_num);
    ACC = [ACC, Accuracy(C,double(gt))];
end
