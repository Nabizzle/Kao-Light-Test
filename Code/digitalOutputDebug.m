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

%turn digital output 1 on and off
pause(0.5);
xippmex('digout', 1, 1);
pause(0.5);
xippmex('digout', 1, 0);
pause(0.5);

now = xippmex('time'); %get the current sample time
[data, time_stamp] = xippmex('cont', 10242, (now - start) / 30, '1ksps', start); %record data on the second SMA analog input between the start and current time

plot(data / 10000);
title('Digital Output');
xlabel('time (ms)');
ylabel('voltage (V)');