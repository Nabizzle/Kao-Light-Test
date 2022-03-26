clc;
clear;
close all;

status = xippmex;
if status ~= 1; error('Xippmex Did Not Initialize');  end
% Wait for xippmex to buffer data from the NIP
pause(0.5);

analog_channels = xippmex('elec', 'analog'); %save the analog channels as a variable

analog_1k_on = sum(xippmex('signal', analog_channels, '1ksps')) > 0; %find a logical value to see if the analog channels are currently sampling at 1,000 samples per second
analog_30k_on = sum(xippmex('signal', analog_channels, '30ksps')) > 0; %find a logical value to see if the analog channels are currently sampling at 30,000 samples per second
settings_changed = 0;

%turn on 1k sampling if it is off
if ~analog_1k_on
    %xippmex('signal', analog_channels, '1ksps', ones(1, length(analog_channels)));
    xippmex('signal', analog_channels, '1ksps', ones(1,length(analog_channels)));
    settings_changed = 1;
end

%turn off 30k sampling if it is on
if analog_30k_on
    xippmex('signal', analog_channels, '30ksps', zeros(1, length(analog_channels)));
    settings_changed = 1;
end

if settings_changed
    pause(0.5); %pause to allow the Grapevine to adjust settings
end

start = xippmex('time'); %get the sample time before the loop
tot_data = [];
stamps = [];
tic;

while(toc < 10)
    pause(0.01)
    now = xippmex('time'); %get the current sample time
    [data, time_stamp] = xippmex('cont', 10241, (now - start) / 30, '1ksps', start); %record data on the first SMA analog input between the start and current time
    start = now; %move the start time to when the last recording window ended
    tot_data = [tot_data, data]; %add the recorded data to the end of the rest of the data
    stamps = [stamps, double(time_stamp) / 30 : (double(time_stamp) / 30 + length(data) - 1)]; %saves the times of the samples
    plot(tot_data / 10000);
    axis([0, 10000, 0, 3.5]);
    title('Foot Pedal Output');
    xlabel('time (ms)');
    ylabel('voltage (V)');   
end
disp('done')