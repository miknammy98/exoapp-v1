function musicamaestro(src,event)
nrchannels = 2;

pahandle = PsychPortAudio('Open', [], 1, 1, 48000, nrchannels);
repetitions = 1;
% Length of the beep
beepLengthSecs = 1/10;
% Start immediately (0 = immediately)
startCue = 0;
% Volumen al que reproducirá el sonido
PsychPortAudio('Volume', pahandle, 0.5);
%% Realizar Beep
 myBeep = MakeBeep(500, beepLengthSecs, 48000);

PsychPortAudio('FillBuffer', pahandle, [myBeep; myBeep]);
PsychPortAudio('Start', pahandle, repetitions, startCue, 1);
[actualStartTime, ~, ~, estStopTime] = PsychPortAudio('Stop', pahandle, 1, 1);
end