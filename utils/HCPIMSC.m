function [R, history, X, omega, G, Z] = HCPIMSC(Xo, Po, Xu, Pu, lambda1, lambda2, c)
% Inputs:
%   Xo - observed parts, a cell array, num_view*1, each array is d_v*n_v
%   Po - projection matrices, a cell array, num_view*1, each array is n_v*n
%   Xu - missing parts, a cell array, num_view*1, each array is d_v*(n-n_v)
%   Pu - projection matrices, a cell array, num_view*1, each array is (n-n_v)*n
%   lambda1,lambda2 - hyperparameters for the algorithm
%   c - number of clusters
% Outputs:
%   R - unified affinity matrix, a n*n array
%   history - reconstruction errors
%   X: reconstructed samples
%   omega - weights of views
%   G - refined view-specific affinity matrices, a cell array, num_view*1, each array is n*n
%   Z - view-specific affinity matrices, a cell array, num_view*1, each array is n*n
% Zhenglai Li, Chang Tang, Xinwang Liu, Xiao Zheng, Wei Zhang, and En Zhu: High-order Correlation Preserved Incomplete Multi-view Subspace Clustering. IEEE Transactions on Image Processing (TIP)
%parameter initial
num_view = length(Xo);
N = size(Po{1}, 2);
%matrix initial
Z = cell(num_view, 1);
G = cell(num_view, 1);
X = cell(num_view, 1);
Xc = cell(num_view, 1);
U = cell(num_view, 1);
V = cell(num_view, 1);
Usq = cell(num_view, 1);
R = zeros(N, N);
for v = 1 : num_view
    Z{v} = zeros(N, N);
    G{v} = zeros(N, N);
    X{v} = Xo{v} * Po{v};
    Xc{v} = Xo{v} * Po{v};
end
G_tensor = zeros(N, N, v);
omega = ones(v, 1) ./ v;
for iter = 1 : 20
    %     fprintf('----processing iter %d--------\n', iter);
    % update Z
    tempZ = zeros(N, N);
    for v = 1 : num_view
        tmp = X{v}' * X{v};
        Z{v} = ((omega(v) + lambda2) * eye(N, N) + tmp)\(tmp + omega(v) * R + lambda2 * G{v});
        Z{v} = Z{v} - diag(diag(Z{v}));
        Z{v} = max(0.5 * (Z{v} + Z{v}'), 0 );
        tempZ = tempZ + omega(v) * Z{v};
    end
    tempZ = tempZ ./ sum(omega);
    R = tempZ - diag(diag(tempZ));
    R = max(0.5 * (R + R'), 0);
    % update omega
    for v = 1 : num_view
        omega(v) = 0.5 / (norm(Z{v} - R, 'fro') + eps);
    end
    % update L
    if iter == 1
        Weight = constructW_PKN(R, 15);
        Diag_tmp = diag(sum(Weight));
        L = Diag_tmp - Weight;
    else
        param.num_view = 15; 
        HG = gsp_nn_hypergraph(R', param);
        L = HG.L;
    end
    % update Xu
    M = cell(num_view, 1);
    for v = 1 : num_view
        M{v} = (Z{v} - eye(N)) * (Z{v} - eye(N))' + lambda1 * L;
        Xu{v} = ( - Xo{v} * Po{v} * M{v} * Pu{v}') / (Pu{v} * M{v} * Pu{v}' );
        [Xu{v}] = NormalizeData(Xu{v});
        % update X
        X{v} = Xc{v} + Xu{v} * Pu{v};
    end
    % update G
    Z_tensor = cat(3, Z{ : , : });
    hatZ = fft(Z_tensor, [], 3);
    if iter == 1
        for v = 1 : num_view
            [Unum_view, Sigmanum_view, Vnum_view] = svds(hatZ( : , : , v), c);
            U{v} = Unum_view * Sigmanum_view;
            V{v} = Vnum_view';
            G_tensor( : , : , v) = U{v} * V{v};
        end
    else
        for v = 1 : num_view
            U{v} = hatZ( : , : , v) * V{v}' * pinv(V{v} * V{v}');
            Usq{v} = U{v}' * U{v};
            V{v} = pinv(Usq{v}) * U{v}' * hatZ( : , : , v);
            G_tensor( : , : , v) = U{v} * V{v};
        end
    end
    G_tensor = ifft(G_tensor, [], 3);
    for v = 1 : num_view
        G{v} = G_tensor( : , : , v);
    end
    %record the iteration information
    history.term1(iter) = 0;
    % coverge condition
    for v = 1 : num_view
        history.term1(iter) = history.term1(iter) + norm(X{v} - X{v} * Z{v}, 'fro') ^ 2 ;
    end
    obj(iter) = history.term1(iter);
    if iter > 2 && abs((obj(iter) - obj(iter - 1)) / obj(iter - 1)) < 1e-4
        break;
    end
end
end