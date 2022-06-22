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


% %Plot figure
% figure(2);
% 
% h1 = subplot (2,1,1);
% set(gca,'FontSize',18);
% % hold on;
% plot(slwNDGau, 'LineWidth',3,'Color','blue');
% hold on;
% plot(slwNDServ, 'LineWidth',3,'Color','cyan');
% hold off
% legend('Gauge','Servomotor');
% title('Slow Rate');
% 
% h2 = subplot (2,1,2);
% set(gca,'FontSize',18);
% % hold on;
% plot(fstNDGau, 'LineWidth',3,'Color','blue');
% hold on;
% plot(fstNDServ, 'LineWidth',3,'Color','cyan');
% hold off
% legend('Gauge','Servomotor');
% title('Fast Rate');

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

for i=1:tempsTotSlw
    TTs(i)=0.1*i;
end
for i=1:tempsTotFst
    TTf(i)=0.1*i;
end


%% Visualize ECG
% load ecgdata
% figure(1);
% subplot(4, 1, 1);
% plot(TTs, XAGals)
% title('Gauge slow Rate Signal')
% subplot(4, 1, 2);
% plot(TTs, XAServs)
% title('ServoMotor slow Rate Signal')
% subplot(4, 1, 3);
% plot(TTf, XAGalf)
% title('Gauge fast Rate Signal')
% subplot(4, 1, 4);
% plot(TTf, XAServf)
% title('ServoMotor fast Rate Signal')

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

%Find error
% idxG=find(EBGau>1.5*std(EBGau));
idxGs=find(EBGaus>1);
idxSs=find(EBServs>4.15*std(EBServs));

idxGf=find(EBGauf>1);
idxSf=find(EBServf>12*std(EBServf));

sizeErrGals = size(SAGals);
sizeErrServs = size(SAServs);
sizeErrGalf = size(SAGalf);
sizeErrServf = size(SAServf);

XAServs = XAServs(1:sizeErrServs(2));
XAGals = XAGals(1:sizeErrGals(2));

XAServf = XAServf(1:sizeErrServf(2));
XAGalf = XAGalf(1:sizeErrGalf(2));

    figure(1);

    h1 = subplot(3, 1, 1);
    set(gca,'FontSize',18);
    hold on;
    plot(1:sizeErrGals(2), XAGals, 'Color', 'k', 'LineWidth',3);
    plot(1:numel(XB_hat_Gaus), XB_hat_Gaus, 'Color', 'b', 'LineWidth',3);
    hold off;
    legend({'Input Signal' 'Reconstructed Signal'});
    title('Reconstruction_ Gauge_SlowRate');
    grid on;
    
    h2 = subplot(3, 1, 2);
    set(gca,'FontSize',18);
    hold on;
    plot(1:sizeErrGals(2), EBGaus, 'Color', 'blue','LineWidth',3);
    plot(idxGs(1):idxGs(end), EBGaus(idxGs(1):idxGs(end)), 'Color', 'red', 'LineWidth',3);
    hold off;
    title('Error');
    grid on;
    
    h3 = subplot(3, 1, 3);
    set(gca,'FontSize',18);
    hold on;
    plot(1:sizeErrGals(2), XAGals, 'Color', 'k', 'LineWidth',3);
    plot(idxGs(1):idxGs(end), XAGals(idxGs(1):idxGs(end)), 'Color', 'red', 'LineWidth',3);
    hold off;
    legend({'Input Signal' 'Reconstructed Signal' 'Anomaly'})
    title('Anomaly detector');
    linkaxes([h1 h2 h3], 'x');
    grid on;


    figure(2);
    h1 = subplot(3, 1, 1);
    set(gca,'FontSize',18);
    hold on;
    plot(1:sizeErrServs(2), XAServs, 'Color', 'k', 'LineWidth',3);
    plot(1:numel(XB_hat_Servs), XB_hat_Servs, 'Color', 'b', 'LineWidth',3);
    hold off;
    legend({'Input Signal' 'Reconstructed Signal'});
    title('Reconstruction_ Servo_SlowRate');
    grid on;
    
    h2 = subplot(3, 1, 2);
    set(gca,'FontSize',18);
    hold on;
    plot(1:sizeErrServs(2), EBServs, 'Color', 'blue','LineWidth',3);
    plot(idxSs(1):idxSs(end), EBServs(idxSs(1):idxSs(end)), 'Color', 'red', 'LineWidth',3);
    hold off;
    title('Error');
    grid on;
    
    h3 = subplot(3, 1, 3);
    set(gca,'FontSize',18);
    hold on;
    plot(1:sizeErrServs(2), XAServs, 'Color', 'k', 'LineWidth',3);
    plot(idxSs(1):idxSs(end), XAServs(idxSs(1):idxSs(end)), 'Color', 'red', 'LineWidth',3);
    hold off;
    legend({'Input Signal' 'Reconstructed Signal' 'Anomaly'})
    title('Anomaly detector');
    linkaxes([h1 h2 h3], 'x');
    grid on;


    figure(3);
    h1 = subplot(3, 1, 1);
    set(gca,'FontSize',18);
    hold on;
    plot(1:sizeErrGalf(2), XAGalf, 'Color', 'k', 'LineWidth',3);
    plot(1:numel(XB_hat_Gauf), XB_hat_Gauf, 'Color', 'b', 'LineWidth',3);
    hold off;
    legend({'Input Signal' 'Reconstructed Signal'});
    title('Reconstruction_ Gauge_FastRate');
    grid on;
    
    h2 = subplot(3, 1, 2);
    set(gca,'FontSize',18);
    hold on;
    plot(1:sizeErrGalf(2), EBGauf, 'Color', 'blue','LineWidth',3);
    plot(idxGf(1):idxGf(end), EBGauf(idxGf(1):idxGf(end)), 'Color', 'red', 'LineWidth',3);
    hold off;
    title('Error');
    grid on;
    
    h3 = subplot(3, 1, 3);
    set(gca,'FontSize',18);
    hold on;
    plot(1:sizeErrGalf(2), XAGalf, 'Color', 'k', 'LineWidth',3);
    plot(idxGf(1):idxGf(end), XAGalf(idxGf(1):idxGf(end)), 'Color', 'red', 'LineWidth',3);
    hold off;
    legend({'Input Signal' 'Reconstructed Signal' 'Anomaly'})
    title('Anomaly detector');
    linkaxes([h1 h2 h3], 'x');
    grid on;


    figure(4);
    h1 = subplot(3, 1, 1);
    set(gca,'FontSize',18);
    hold on;
    plot(1:sizeErrServf(2), XAServf, 'Color', 'k', 'LineWidth',3);
    plot(1:numel(XB_hat_Servf), XB_hat_Servf, 'Color', 'b', 'LineWidth',3);
    hold off;
    legend({'Input Signal' 'Reconstructed Signal'});
    title('Reconstruction_ Servo_FastRate');
    grid on;
    
    h2 = subplot(3, 1, 2);
    set(gca,'FontSize',18);
    hold on;
    plot(1:sizeErrServf(2), EBServf, 'Color', 'blue','LineWidth',3);
    plot(idxSf(1):idxSf(end), EBServf(idxSs(1):idxSf(end)), 'Color', 'red', 'LineWidth',3);
    hold off;
    title('Error');
    grid on;
    
    h3 = subplot(3, 1, 3);
    set(gca,'FontSize',18);
    hold on;
    plot(1:sizeErrServf(2), XAServf, 'Color', 'k', 'LineWidth',3);
    plot(idxSf(1):idxSf(end), XAServf(idxSf(1):idxSf(end)), 'Color', 'red', 'LineWidth',3);
    hold off;
    legend({'Input Signal' 'Reconstructed Signal' 'Anomaly'})
    title('Anomaly detector');
    linkaxes([h1 h2 h3], 'x');
    grid on;