    function ParaTimer(src, event)
    disp('Paro el timer!');
        data.dataGalga = src.UserData.galga(2,:);       % En aquest apartat es registren les dades a dins de dues 
        data.dataServo = src.UserData.galga(1,:);       % estructures, data i userinfo, d'aquesta manera es poden
        data.timeStamp = src.UserData.galga(3,:);       % utilitzar de forma més àgil
        userInfo.edad = str2num(evalin('base','edad')); 
        userInfo.peso = str2num(evalin('base','peso'));
        data.repeticiones  = src.UserData.repeticiones;
        data.periodoLento = evalin('base','ps');
        data.periodoRapido = evalin('base','pr');
        if evalin('base','sano') == 1
            userInfo.patologia = 'paciente sano';
        else
            userInfo.patologia = 'paciente con patología';
        end
        userInfo.sexo = evalin('base','sexo');
        
        nombreCarpeta = evalin('base','ID');
        eval(nombreCarpeta);
        Screen('CloseAll');
        % Aquí es crida la funció que crea l'app
        run('identDL\identSig_exoapp.m');
        
    

end
