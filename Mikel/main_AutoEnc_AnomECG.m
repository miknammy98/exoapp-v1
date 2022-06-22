%-------------------------------------------------------------------------%
% Created by Xavier Marimon. 2020-2021. xavier.marimon@upc.edu
% This code is licensed under a Creative Commons License (CC).
%-------------------------------------------------------------------------%

%%%%%%%%%%%%%%% Anomaly detection of ECG using autoencoder %%%%%%%%%%%%%%%%

for i=1:300
    TA(i)=0.1*i;
end

%% Visualize ECG
% load ecgdata
figure(1);
subplot(2, 1, 1);
plot(TA, XA)
title('Nomal ECG')
subplot(2, 1, 2);
plot(TA, XB);
title('ECG which may contains abnormality')

%% Generate subsequece time series

w = 20;

SA = generateSubseq(XA, w)';
SB = generateSubseq(XB, w)';

% %% Train autoencoder

autoenc = trainAutoencoder(SA, 160, ...
    'MaxEpochs', 3000, ...
    'L2WeightRegularization', 1.0e-10, ...
    'SparsityRegularization', 1.0e-10, ...
    'SparsityProportion', 0.7, ...
    'ScaleData', true, ...
    'UseGPU', true);

%Load trained autoencoder
% load('autoenc.mat');

%% Predict
SB_hat = predict(autoenc, SB);
XB_hat = SB_hat(1, :);

%% Calculate prediction error
EB = sqrt(sum((SB_hat - SB).^2));
%Find error
idx=find(EB>1.5*std(EB));

sizeErr = size(SA);
XB=XB(1:sizeErr(2));
XA=XA(1:sizeErr(2));

    figure(2);
    h1 = subplot(3, 1, 1);
    set(gca,'FontSize',18);
    hold on;
    plot(1:sizeErr(2), XB, 'Color', 'k', 'LineWidth',3);
    plot(1:numel(XB_hat), XB_hat, 'Color', 'b', 'LineWidth',3);
    legend({'Input Signal' 'Reconstructed Signal'});
    title('Reconstruction');
    grid on;
    
    h2 = subplot(3, 1, 2);
    set(gca,'FontSize',18);
    hold on;
    plot(1:sizeErr(2), EB, 'Color', 'blue','LineWidth',3);
    plot(idx(1):idx(end), EB(idx(1):idx(end)), 'Color', 'red', 'LineWidth',3);
    title('Error');
    grid on;
    
    h3 = subplot(3, 1, 3);
    set(gca,'FontSize',18);
    hold on;
    plot(1:sizeErr(2), XB, 'Color', 'k', 'LineWidth',3);
    plot(idx(1):idx(end), XB(idx(1):idx(end)), 'Color', 'red', 'LineWidth',3);
    legend({'Input Signal' 'Reconstructed Signal' 'Anomaly'})
    title('Anomaly detector');
    linkaxes([h1 h2 h3], 'x');
    grid on;




