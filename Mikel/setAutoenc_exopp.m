% NormalData 4 Autoenc
load('F:\documentos TFG\archivos matlab\app\Scripts V.F.5.2\OutputData\mk1____2022-06-09_14-54.mat')

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
slwNDTS=data.timeStamp(posSlw);

%Create Fast normal data 
fstNDServ=data.dataGalga(posFst);
fstNDGau=data.dataServo(posFst);
fstNDTS=data.timeStamp(posFst);

%Standarize train data
XAGal=normalize(slwNDGau)';
XAServ=normalize(slwNDServ)';
XAGalf=normalize(fstNDGau)';
XAServf=normalize(fstNDServ)';
%Standarize test data

te = size(XAGal);
tempsTot = te(1);

for i=1:tempsTot
    TT(i)=0.1*i;
end

w = 20;

SAGal = generateSubseq(XAGalf, w)';
SAServ = generateSubseq(XAServf,w)';

% %% Train autoencoder

autoencGalfastW20 = trainAutoencoder(SAGal, 160, ...
    'MaxEpochs', 3000, ...
    'L2WeightRegularization', 1.0e-10, ...
    'SparsityRegularization', 1.0e-10, ...
    'SparsityProportion', 0.7, ...
    'ScaleData', true, ...
    'UseGPU', true);