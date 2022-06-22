function Y = combineSubseq(X, W, S)
% COMBINESUBSEQ Convert subsequence into original sequence
%
%   Y = combineSubseq(X, W, S)
%
%       X : sub sequence
%       W : size of sliding window
%       S : size of stride

% Copyright 2017 The MathWorks, Inc.

[M, N] = size(X);

numCH = N / W;
numData_effective = (M - 1) * S + W;

J = generateSubseq((1:numData_effective)', W, S);

XX = cell(numCH, 1);

for ch = 1:numCH
    
    Xch = X(:, (1:W) + (ch - 1) * W);
    XX{ch} = combine(Xch, J, numData_effective);
    
end

Y = cat(2, XX{:});

end

