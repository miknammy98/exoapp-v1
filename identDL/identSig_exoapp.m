load('autoencGalslowW20.mat');
load('autoencServslowW20.mat');
load('autoencGalfastW20.mat');
load('autoencServfastW20.mat');

%Selection slow period
pos2=find(data.timeStamp==2);
pos4=find(data.timeStamp==4);
posSlw=[pos2  pos4];

%Selection fast period
pos6=find(data.timeStamp==6);
pos8=find(data.timeStamp==8);
posFst=[pos6  pos8];

%Create Slow normal data Slow
slwNDServ=data.dataGalga(posSlw);
slwNDGau=data.dataServo(posSlw);
%Create Fast normal data 
fstNDServ=data.dataGalga(posFst);
fstNDGau=data.dataServo(posFst);

%Detrend anomaly data
slwNDGau_detr=detrend(slwNDGau);
slwNDServ_detr=detrend(slwNDServ);
fstNDGau_detr=detrend(fstNDGau);
fstNDServ_detr=detrend(fstNDServ);



%Standarize anomaly data
XAGals=normalize(slwNDGau)';
XAServs=normalize(slwNDServ)';
XAGalf=normalize(fstNDGau)';
XAServf=normalize(fstNDServ)';

tslw = size(XAGals);
tfst = size(XAGalf);

tempsTotSlw = tslw(1);
tempsTotFst = tfst(1);

% for i=1:tempsTotSlw
%     TTs(i)=0.1*i;
% end
% for i=1:tempsTotFst
%     TTf(i)=0.1*i;
% end

%dividir señal
w = 20;

SAGals = generateSubseq(XAGals, w)';
SAServs = generateSubseq(XAServs,w)';
SAGalf = generateSubseq(XAGalf, w)';
SAServf = generateSubseq(XAServf,w)';

%% Predict
SB_hat_Gaus = predict(autoencGalslowW20, SAGals);
SB_hat_Servs = predict(autoencServslowW20, SAServs);
XB_hat_Gaus = SB_hat_Gaus(1, :);
XB_hat_Servs = SB_hat_Servs(1, :);

SB_hat_Gauf = predict(autoencGalfastW20, SAGalf);
SB_hat_Servf = predict(autoencServfastW20, SAServf);
XB_hat_Gauf = SB_hat_Gauf(1, :);
XB_hat_Servf = SB_hat_Servf(1, :);

%% Calculate prediction error
EBGaus = sqrt(sum((SB_hat_Gaus - SAGals).^2));
EBServs = sqrt(sum((SB_hat_Servs - SAServs).^2));

EBGauf = sqrt(sum((SB_hat_Gauf - SAGalf).^2));
EBServf = sqrt(sum((SB_hat_Servf - SAServf).^2));

%% Find error
idxGs=find(EBGaus>5*std(EBGaus));
idxSs=find(EBServs>4.15*std(EBServs));

idxGf=find(EBGauf>5.7*std(EBGauf));
idxSf=find(EBServf>5*std(EBServf));
%% Create a mask Vector with NaN values
j=1;
GsL=size(idxGs');
for i = 1:size(EBGaus')
    MskGs(1,i)=nan;
    MskGs(2,i)=nan;
    if GsL(1)>=1 & i == idxGs(j)
        MskGs(1,i)=EBGaus(i);
        MskGs(2,i)=XAGals(i);
         if i< GsL(1)
        j=1+j;
         end
    end
end

j=1;
GfL=size(idxGf');
for i=1:size(EBGauf')
    MskGf(1,i) = nan;
    MskGf(2,i) = nan;
    if GfL(1)>=1 & i == idxGf(j)
        MskGf(1,i)=EBGauf(i);
        MskGf(2,i)=XAGalf(i);
        if j<GfL(1)
        j=1+j;
        end
    end
end

j=1;
SsL=size(idxSs');
for i=1:size(EBServs')
    MskSs(1,i) = nan;
    MskSs(2,i) = nan;
    if SsL(1)>=1 & i == idxSs(j)
        MskSs(1,i)=EBServs(i);
        MskSs(2,i) = XAServs(i);
        if j<SsL(1)
        j=1+j;
        end
    end
end

j=1;
SfL=size(idxSf');
for i=1:size(EBServf')
    MskSf(1,i) = nan;
    MskSf(2,i) = nan;
    if SfL(1)>=1 & i == idxSf(j)
        MskSf(1,i)=EBServf(i);
        MskSf(2,i)=XAServf(i);
        if j<SfL(1)
        j=1+j;
        end
    end
end

%Find error
% idxGs=find(EBGaus>5*std(EBGaus));
% idxSs=find(EBServs>4.15*std(EBServs));
% 
% idxGf=find(EBGauf>7.5*std(EBGauf));
% idxSf=find(EBServf>5*std(EBServf));

sizeErrGals = size(SAGals);
sizeErrServs = size(SAServs);
sizeErrGalf = size(SAGalf);
sizeErrServf = size(SAServf);

XAServs = XAServs(1:sizeErrServs(2));
XAGals = XAGals(1:sizeErrGals(2));

XAServf = XAServf(1:sizeErrServf(2));
XAGalf = XAGalf(1:sizeErrGalf(2));

%     figure(1);
% 
%     h1 = subplot(3, 1, 1);
%     set(gca,'FontSize',18);
%     hold on;
%     plot(1:sizeErrGals(2), XAGals, 'Color', 'k', 'LineWidth',3);
%     plot(1:numel(XB_hat_Gaus), XB_hat_Gaus, 'Color', 'b', 'LineWidth',3);
%     hold off;
%     legend({'Input Signal' 'Reconstructed Signal'});
%     title('Reconstruction_ Gauge_SlowRate');
%     grid on;
%     
%     h2 = subplot(3, 1, 2);
%     set(gca,'FontSize',18);
%     hold on;
%     plot(1:sizeErrGals(2), EBGaus, 'Color', 'blue','LineWidth',3);
%     plot(MskGs(1,:), 'Color', 'red', 'LineWidth',3);
%     hold off;
%     title('Error');
%     grid on;
%     
%     h3 = subplot(3, 1, 3);
%     set(gca,'FontSize',18);
%     hold on;
%     plot(1:sizeErrGals(2), XAGals, 'Color', 'k', 'LineWidth',3);
% %     plot(XAGals(idxGs), 'Color', 'red', 'LineWidth',3);
%     plot(MskGs(2,:), 'Color', 'red', 'LineWidth',3);
%     hold off;
%     legend({'Input Signal' 'Reconstructed Signal' 'Anomaly'})
%     title('Anomaly detector');
%     linkaxes([h1 h2 h3], 'x');
%     grid on;



%     figure(2);
%     h1 = subplot(3, 1, 1);
%     set(gca,'FontSize',18);
%     hold on;
%     plot(1:sizeErrServs(2), XAServs, 'Color', 'k', 'LineWidth',3);
%     plot(1:numel(XB_hat_Servs), XB_hat_Servs, 'Color', 'b', 'LineWidth',3);
%     hold off;
%     legend({'Input Signal' 'Reconstructed Signal'});
%     title('Reconstruction_ Servo_SlowRate');
%     grid on;
%     
%     h2 = subplot(3, 1, 2);
%     set(gca,'FontSize',18);
%     hold on;
%     plot(1:sizeErrServs(2), EBServs, 'Color', 'blue','LineWidth',3);
% %     plot(idxSs(1):idxSs(end), EBServs(idxSs(1):idxSs(end)), 'Color', 'red', 'LineWidth',3);
%     plot(MskSs(1,:), 'Color', 'red', 'LineWidth',3);
%     hold off;
%     title('Error');
%     grid on;
%     
%     h3 = subplot(3, 1, 3);
%     set(gca,'FontSize',18);
%     hold on;
%     plot(1:sizeErrServs(2), XAServs, 'Color', 'k', 'LineWidth',3);
% %     plot(idxSs(1):idxSs(end), XAServs(idxSs(1):idxSs(end)), 'Color', 'red', 'LineWidth',3);
%     plot(MskSs(2,:), 'Color', 'red', 'LineWidth',3);
%     hold off;
%     legend({'Input Signal' 'Reconstructed Signal' 'Anomaly'})
%     title('Anomaly detector');
%     linkaxes([h1 h2 h3], 'x');
%     grid on;
% 
% 
%     figure(3);
%     h1 = subplot(3, 1, 1);
%     set(gca,'FontSize',18);
%     hold on;
%     plot(1:sizeErrGalf(2), XAGalf, 'Color', 'k', 'LineWidth',3);
%     plot(1:numel(XB_hat_Gauf), XB_hat_Gauf, 'Color', 'b', 'LineWidth',3);
%     hold off;
%     legend({'Input Signal' 'Reconstructed Signal'});
%     title('Reconstruction_ Gauge_FastRate');
%     grid on;
%     
%     h2 = subplot(3, 1, 2);
%     set(gca,'FontSize',18);
%     hold on;
%     plot(1:sizeErrGalf(2), EBGauf, 'Color', 'blue','LineWidth',3);
% %     plot(EBGauf(idxGf), 'Color', 'red', 'LineWidth',3);
%     plot(MskGf(1,:), 'Color', 'red', 'LineWidth',3);
%     hold off;
%     title('Error');
%     grid on;
%     
%     h3 = subplot(3, 1, 3);
%     set(gca,'FontSize',18);
%     hold on;
%     plot(1:sizeErrGalf(2), XAGalf, 'Color', 'k', 'LineWidth',3);
% %     plot(XAGalf(idxGf), 'Color', 'red', 'LineWidth',3);
%     plot(MskGf(2,:), 'Color', 'red', 'LineWidth',3);
%     hold off;
%     legend({'Input Signal' 'Reconstructed Signal' 'Anomaly'})
%     title('Anomaly detector');
%     linkaxes([h1 h2 h3], 'x');
%     grid on;
% 
% 
%     figure(4);
%     h1 = subplot(3, 1, 1);
%     set(gca,'FontSize',18);
%     hold on;
%     plot(1:sizeErrServf(2), XAServf, 'Color', 'k', 'LineWidth',3);
%     plot(1:numel(XB_hat_Servf), XB_hat_Servf, 'Color', 'b', 'LineWidth',3);
%     hold off;
%     legend({'Input Signal' 'Reconstructed Signal'});
%     title('Reconstruction_ Servo_FastRate');
%     grid on;
%     
%     h2 = subplot(3, 1, 2);
%     set(gca,'FontSize',18);
%     hold on;
%     plot(1:sizeErrServf(2), EBServf, 'Color', 'blue','LineWidth',3);
% %     plot(EBServf(idxSf), 'Color', 'red', 'LineWidth',3);
%     plot(MskSf(1,:), 'Color', 'red', 'LineWidth',3);
%     hold off;
%     title('Error');
%     grid on;
%     
%     h3 = subplot(3, 1, 3);
%     set(gca,'FontSize',18);
%     hold on;
%     plot(1:sizeErrServf(2), XAServf, 'Color', 'k', 'LineWidth',3);
% %     plot(XAServf(idxSf), 'Color', 'red', 'LineWidth',3);
%     plot(MskSf(2,:), 'Color', 'red', 'LineWidth',3);
%     hold off;
%     legend({'Input Signal' 'Reconstructed Signal' 'Anomaly'})
%     title('Anomaly detector');
%     linkaxes([h1 h2 h3], 'x');
%     grid on;
 
save var.mat XAServs XB_hat_Servs MskSs EBServs XAServf XB_hat_Servf MskSf EBServf XAGals XB_hat_Gaus MskGs EBGaus XAGalf XB_hat_Gauf MskGf EBGauf
run('F:\documentos TFG\exoapp v1\Diagnosi_2_exoapp.mlapp');           