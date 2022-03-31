function [targetTestPeriods] = laserStateWaveScrape(timing_wave, targets)
%timingWaveScrape Find the time periods of the tests and organize them by
%test type.
%   this script finds the corners of the square waves that indicate the
%   test periods and saves them with a list of what test was happening at
%   the time. note that every other square wave starting with the second
%   one is a test and the others are the priming phase.
close all;
x = timing_wave(2, :);
x(end) = 0;

%smooths out the square waves
x(x < 50) = 0;
for i = 1000 : 500 : 5000
    x(x > (i - 499) & x < i) = i - 500;
end

x_zero = x;
x_zero(x_zero > 1) = 1;
x_zero = find(x == 0);%find where the signal is zero

%find the derivative of the zeros of the timing wave to find the corners of the square
%wave
slopes = diff(x_zero);

x_index_temp = [(x_zero((find(slopes ~= 1)))'),(x_zero((find(slopes ~= 1))+1)')];%find the corners and add the corners that will be missed

%reorder the temporary xindex to the correct order of test periods
x_index = [];
for i = 1 : length(x_index_temp)
    x_index = [x_index, x_index_temp(i, 1)];
    x_index = [x_index, x_index_temp(i, 2)];
end

%eliminates found points that are too close together and the last point if it was added needlessly
correction = diff(x_index);
correction = [3000, correction];
x_index = x_index(correction < 0 | correction > 1000);

%plot the timing wave with the found corners to debugging
figure;
plot(timing_wave(1, :), x);
hold all;
plot(timing_wave(1, x_index), x(x_index), 'o');
title('Timing Wave');
xlabel('ms');
ylabel('mV');
axis([timing_wave(1, 1), timing_wave(1, end), 0, 21000]);

%reshape the array into a matrix of start and stop times.
testPeriods = reshape(timing_wave(1, x_index), [2, length(x_index) / 2]);
testPeriods = testPeriods';

targetTestPeriods = [testPeriods, targets'];%add the test type to the matrix next to the timing
end