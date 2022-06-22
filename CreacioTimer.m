t=timer;
t.StartFcn = @InicialitzaTimer;
t.TimerFcn = @AccioTimer;
t.StopFcn = @ParaTimer;
t.Period   = .1; % period in seconds
t.TasksToExecute = str2num(evalin('base','repeticiones'))*50+150;   % number of tasks to be executed
t.ExecutionMode = 'fixedRate';
%%
start(t); % start the timer
wait(t); % blocks the command prompt until timer, t, stops running
stop(t); % stops the timer
delete(t); % deletes timer object

% clear all