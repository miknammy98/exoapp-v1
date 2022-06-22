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

for i=1:tempsTotSlw
    TTs(i)=0.1*i;
end
for i=1:tempsTotFst
    TTf(i)=0.1*i;
end

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

idxGf=find(EBGauf>7.5*std(EBGauf));
idxSf=find(EBServf>5*std(EBServf));
%%%%%%%%%%%%%%%%
%% Mask
j=1;
SsL=size(idxSs');
for i=1:size(EBServs')
    MskSs(i) = nan;
    if size(SsL(1))>=1 & i == idxSs(j)
        MskSs(i)=EBServs(i);
        if j<SsL(1)
        j=1+j;
        end
    end
end