%% simplemente las pantallas
function  CreacionPantalla(src,event)

PsychDefaultSetup(2);
Screen('CloseAll');
Screen('Preference', 'SkipSyncTests', 1);
screens = Screen('Screens');
screenNumber = max(screens);

[src.UserData.window, src.UserData.windowRect] = PsychImaging('OpenWindow', screenNumber, [0.75 0.25 0.15]); 

Screen('TextSize', src.UserData.window, 90);
Screen('TextFont',src.UserData.window,'Times');
end 