    function AccioTimer(src, event)
     TasquesExecutades = src.TasksExecuted;
%     disp(TasquesExecutades)
    disp(src.TasksExecuted);   
%% Accions
    %Reposo
    if src.TasksExecuted >= 1 && src.TasksExecuted <= 48    
        gau = src.UserData.offset; 
        src.UserData.offset = readVoltage(src.UserData.ard,"A0");
%         disp(src.UserData.offset);
        src.UserData.offset = gau + src.UserData.offset;
        src.UserData.n=src.UserData.n+1;
        src.UserData.tS = 0;
%Ajustando Offset    
    elseif src.TasksExecuted == 49                          
        src.UserData.offset= src.UserData.offset/src.UserData.n;
        src.UserData.estado = "Flexionar";
        disp(src.UserData.estado);
        disp(src.UserData.offset);
% Inicio del primer Ejercicio
%     elseif rem(src.TasksExecuted - 50,src.UserData.repInicio) == 0 && src.TasksExecuted > 49 && src.TasksExecuted <= src.UserData.fin1rEj-1 
    elseif src.TasksExecuted > 49 && src.TasksExecuted <= src.UserData.fin1rEj-1 
        if rem(src.TasksExecuted - 50,src.UserData.ps*10) == 0
        %Cambio entre Flexión y Extensión Empezando por la Flexión
        movimientoBrazo(src,event);
%         elseif rem(src.TasksExecuted - 50,5) >= 1                    %%%%%%%%%%%%%%%%%
%             src.UserData.difTaskExec = rem(src.TasksExecuted - 50,15);
%             if src.UserData.difTaskExec < 5
%                 src.UserData.text = '............';
%             elseif src.UserData.difTaskExec >= 5 && src.UserData.difTaskExec < 10
%                 src.UserData.text = '........';
%             elseif src.UserData.difTaskExec >=10 && src.UserData.difTaskExec < 15
%                 src.UserData.text = '....';
%             end
            CambioPantalla(src,event);                                %%%%%%%%%%%%%%%%%
        end
    % Reposo y Cambio de Velocidad
    elseif rem(src.TasksExecuted,src.UserData.fin1rEj) == 0 && src.TasksExecuted <= src.UserData.fin1rEj + 49
        %Descanso
            src.UserData.estado = "Reposo";
            disp('descanso');
            src.UserData.velocidad = 2;
            src.UserData.cuentReg = 0;
            src.UserData.tS = 0;
            CambioPantalla(src,event);
            src.UserData.estado = "Flexionar"
    % Inicio del Segundo Ejercicio
%     elseif rem(src.TasksExecuted - src.UserData.fin1rEj + 50,src.UserData.repFinal) == 0 && src.TasksExecuted > src.UserData.fin1rEj+49 && src.TasksExecuted <= src.UserData.fin2oEj-1
    elseif src.TasksExecuted > src.UserData.fin1rEj+49 && src.TasksExecuted <= src.UserData.fin2oEj-1
        
        if rem(src.TasksExecuted - src.UserData.fin1rEj + 50,src.UserData.pr*10) == 0
        %Cambio entre Flexión y Extensión Empezando por la Flexión
        movimientoBrazo(src,event);
        elseif rem(src.TasksExecuted - 50,5) >= 1                    %%%%%%%%%%%%%%%%%
            src.UserData.difTaskExec = rem(src.TasksExecuted - 50,10);%%%%%%%%%%%%%%%%%
            CambioPantalla(src,event);                                %%%%%%%%%%%%%%%%%
        end
    elseif src.TasksExecuted == src.UserData.fin2oEj +1
        % Descanso y Fin de los Ejercicios
        src.UserData.estado = "Fin";
        disp('Fin EJERCICIOS');
        src.UserData.tS = 0;
        CambioPantalla(src,event);        
    end
% Guardar la información de la Galga, el Servo y el TimeStamp.
gauDat=readVoltage(src.UserData.ard,src.Userdata.pinGalga)*0.48;
serDat=readVoltage(src.UserData.ard,src.Userdata.pinServo)-src.UserData.offset;
src.UserData.galga(1,TasquesExecutades) = gauDat;
src.UserData.galga(2,TasquesExecutades) = serDat;
src.UserData.galga(3,TasquesExecutades) = src.UserData.tS;
    
end