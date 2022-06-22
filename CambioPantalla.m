% function CambioPantalla(src.UserData.window,text,freq,pahandle) 
function CambioPantalla(src,event)
if src.UserData.tS==0 && src.UserData.estado == "Reposo"
    color=[1 0 1];
    text = 'Repose'; 
elseif src.UserData.tS==0 && src.UserData.estado == "Fin"
    color=[.45 .98 1]; 
    text= 'Fin de los Ejercicios';
elseif src.UserData.tS==4 || src.UserData.tS==8
    color=[ 0 1 0];
    text= 'Flexione';
elseif src.UserData.tS==2 || src.UserData.tS==6
    color=[ 0.8 0.28 0.07];
    text= 'Extienda';

elseif src.UserData.cuentReg == 1
end
    Screen('FillRect',src.UserData.window,color);
    DrawFormattedText(src.UserData.window, text, 'center','center', [0 0 0]);
%     DrawFormattedText(src.UserData.window, src.UserData.text, 'center','bottom', [0 0 0]);
    Screen('Flip', src.UserData.window); 
%     MusicaMaestro(freq,pahandle);
end