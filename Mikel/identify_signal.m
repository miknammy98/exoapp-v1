load('autoencw50.mat');


% %Plot figure
% figure(1);
% plot(data.dataGalga, 'LineWidth',3,'Color','green');
% hold on;
% plot(data.dataServo, 'LineWidth',2,'Color','cyan');
% plot(data.timeStamp, 'LineWidth',3,'Color','black');


%Selection slow period
pos2=find(data.timeStamp==2);
pos4=find(data.timeStamp==4);
posSlw=[pos2  pos4];

%Selection fast period
pos6=find(data.timeStamp==6);
pos8=find(data.timeStamp==8);
posFst=[pos6  pos8];

%Create Slow normal data Slow
slwNDGau=data.dataGalga(posSlw);
slwNDServ=data.dataServo(posSlw);
slwNDTS=data.timeStamp(posSlw);

%Create Fast normal data 
fstNDGau=data.dataGalga(posFst);
fstNDServ=data.dataServo(posFst);
fstNDTS=data.timeStamp(posFst);

%Plot figure
figure(2);

h1 = subplot (2,1,1);
set(gca,'FontSize',18);
% hold on;
plot(slwNDGau, 'LineWidth',3,'Color','blue');
hold on;
plot(slwNDServ, 'LineWidth',3,'Color','cyan');
hold off
legend('Gauge','Servomotor');
title('Slow Rate');

h2 = subplot (2,1,2);
set(gca,'FontSize',18);
% hold on;
plot(fstNDGau, 'LineWidth',3,'Color','blue');
hold on;
plot(fstNDServ, 'LineWidth',3,'Color','cyan');
hold off
legend('Gauge','Servomotor');
title('Fast Rate');

%Detrend train data
slwNDGau_detr=detrend(slwNDGau);
slwNDServ_detr=detrend(slwNDServ);

% anomalydata_detr=detrend(anomalydata);

%Standarize train data
XAGal=normalize(slwNDGau)';
XAServ=normalize(slwNDServ)';
%Standarize test data
% XB=normalize(anomalydata_detr)';


te = size(XAGal);
tempsTot = te(1);

for i=1:tempsTot
    TT(i)=0.1*i;
end

%% Visualize ECG
% load ecgdata
figure(1);
subplot(2, 1, 1);
plot(TT, XAGal)
title('Gauge normal Signal')
subplot(2, 1, 2);
plot(TT, XAServ)
title('ServoMotor normal Signal')
% subplot(3, 1, 3);
% % plot(TT, XB);
% title('ECG which may contains abnormality')

w = 20;

SAGal = generateSubseq(XAGal, w)';
SAServ = generateSubseq(XAServ,w)';
% SB = generateSubseq(XB, w)';


%% Predict
SB_hat_Gau = predict(autoenc, SAGal);
SB_hat_Serv = predict(autoenc, SAServ);
XB_hat_Gau = SB_hat_Gau(0.7, :);
XB_hat_Serv = SB_hat_Serv(1, :);

%% Calculate prediction error
EBGau = sqrt(sum((SB_hat_Gau - SAGal).^2));
EBServ = sqrt(sum((SB_hat_Serv - SAServ).^2));
%Find error
% idxG=find(EBGau>1.5*std(EBGau));
idxG=find(EBGau>1);
idxS=find(EBServ>1.5*std(EBServ));

sizeErr = size(SAGal);
XAServ = XAServ(1:sizeErr(2));
XAGal = XAGal(1:sizeErr(2));

    figure(2);
    h1 = subplot(3, 1, 1);
    set(gca,'FontSize',18);
    hold on;
    plot(1:sizeErr(2), XAGal, 'Color', 'k', 'LineWidth',3);
    plot(1:numel(XB_hat_Gau), XB_hat_Gau, 'Color', 'b', 'LineWidth',3);
    hold off;
    legend({'Input Signal' 'Reconstructed Signal'});
    title('Reconstruction');
    grid on;
    
    h2 = subplot(3, 1, 2);
    set(gca,'FontSize',18);
    hold on;
    plot(1:sizeErr(2), EBGau, 'Color', 'blue','LineWidth',3);
    
     plot(idxG(1):idxG(end), EBGau(idxG(1):idxG(end)), 'Color', 'red', 'LineWidth',3);
    hold off;
    title('Error');
    grid on;
    
    h3 = subplot(3, 1, 3);
    set(gca,'FontSize',18);
    hold on;
    plot(1:sizeErr(2), XAGal, 'Color', 'k', 'LineWidth',3);
    plot(idxG(1):idxG(end), XAGal(idxG(1):idxG(end)), 'Color', 'red', 'LineWidth',3);
    hold off;
    legend({'Input Signal' 'Reconstructed Signal' 'Anomaly'})
    title('Anomaly detector');
    linkaxes([h1 h2 h3], 'x');
    grid on;