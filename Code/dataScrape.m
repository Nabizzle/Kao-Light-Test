clc;
clear;
close all;

laser_state_file_struct = dir('Laser*.*'); %Find state recording and save its name
laser_state_data = laser_state_file_struct.name;

servo_angle_file_struct = dir('Servo*.*'); %Find the recording of the servo angle array indicies and save its name
servo_angle_data = servo_angle_file_struct.name;

foot_pedal_file_struct = dir('Foot*.*'); %Find foot pedal recording and save its name
foot_pedal_data = foot_pedal_file_struct.name;

%load in the laser state and servo angle data;
load(laser_state_data);
load(servo_angle_data);

test_periods = laserStateWaveScrape(laser_state_wave, targets); %find the testing periods and pair them with the angle used in the test

%load in the foot pedal data
load(foot_pedal_data);

%find the react time in each test period from the foot pedal being pressed.
foot_pedal_rt = nan(length(test_periods), 1); %setup the array
for i = 1 : length(test_periods)
    test_start = find(foot_pedal_wave(1, :) == test_periods(i, 1)); %find the test start time
    test_end = find(foot_pedal_wave(1, :) == test_periods(i, 2)); %find the test end time
    rt = find(foot_pedal_wave(2, test_start : test_end) > 1000, 1); %find the first time the foot pedal data rises in the test period
    %save the reaction time if it exists
    if ~isempty(rt)
        foot_pedal_rt(i) = rt;
    end
end

%convert the target array to a list from 1 - 28
targets = mod(targets, 28);
targets(targets == 0) = 28;

%sort the targets in order to sort the reaction times
[targets_sorted,sort_index] = sort(targets,'ascend');
sorted_reaction_times = foot_pedal_rt(sort_index);

%Put each test into a column
reshaped_reaction_times = reshape(sorted_reaction_times, [5, 28]);
averaged_reaction_times = nanmean(reshaped_reaction_times);
figure;
plot(averaged_reaction_times);
hold all;
scatter(targets_sorted, sorted_reaction_times);