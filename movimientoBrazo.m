%función de flexión o Extensión
function movimientoBrazo(src, event)
    
    if src.UserData.estado == "Flexionar"
        if src.UserData.velocidad == 1
            src.UserData.tS = 4;
        else
            src.UserData.tS =8;
        end
        src.UserData.estado = "Extender";
        musicaMaestro(src,event);
    elseif src.UserData.estado == "Extender"
        if src.UserData.velocidad == 1
            src.UserData.tS = 2;
        else
            src.UserData.tS =6;
        end
        src.UserData.estado = "Flexionar";
        musicaMaestro(src,event);
    end
CambioPantalla(src,event);
end