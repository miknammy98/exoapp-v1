function InicialitzaTimer(src, event)
    clc;
    close all;
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp('Timer initialisation begins...');
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
%% Inicializar arduino
    src.UserData.ard = arduino("COM4","Uno","BaudRate",115200);
    src.Userdata.pinGalga = 'A3';
    src.UserData.pinServo = 'A0';
%% Inicializar variables 
    src.UserData.tS = 0;        % TimeStamp
    src.UserData.offset = 0;    % Offset de la galga
    src.UserData.n = 0;         % Contador de valores registrados
    src.UserData.estado = "Reposo";
    src.UserData.velocidad = 1;
    src.UserData.repeticiones = str2num(evalin('base','repeticiones'));
    src.UserData.ps = evalin('base','ps');
    src.UserData.pr = evalin('base','pr');
    
    disp('REPETICIONES: ' + src.UserData.repeticiones);
    
    src.UserData.repInicio = src.UserData.repeticiones*2*src.UserData.ps;
    src.UserData.repFinal  = src.UserData.repeticiones*2*src.UserData.pr;
    src.UserData.fin1rEj = src.UserData.repInicio*10 + 50;
    src.UserData.fin2oEj = src.UserData.fin1rEj + 50 + src.UserData.repFinal*10;
    src.UserData.freq    =    44100;
    src.UserData.difTaskExec = 0;
%     src.UserData.text = '';
    
    
    
%% Inicialización Psychtoolbox
     CreacionPantalla(src,event);
     CambioPantalla(src,event);
%% Fin de la Inicialización
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp('Timer initialisation ended!');
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
end
