function Y = generateSubseq(X, W, S)
% GENERATESUBSEQ Generate subsequence time series
%
%   Y = generateSubseq(X, W, S)
%
%       X : time series data
%       W : size of sliding window
%       S : size of stride

% Copyright 2017 The MathWorks, Inc.

if nargin < 3
    S = 1;
end

[T, M] = size(X);

% Calculate the Number of Subsequence Time series
K = T - W + 1;

% Calculate indexes
idx = repmat(1:W, K, 1)' + repmat(1:K, W, 1) - 1;
idx = idx(:, 1:S:K);

% Extract subsequence time series
idx = idx(:);
X = X';
Y = X(:, idx);

% Reshape matrix
Y = reshape(Y, M * W, [])';

% Reallocate data
idx = 1:(M * W);
idx = reshape(idx, M, [])';
idx = idx(:)';

Y = Y(:, idx);
