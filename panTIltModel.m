clc;
clear;
close all;

%position for the laser
commandPosition = [0, 40];

%reference values for the tower pro 9g micro servo
servoHeight = 26.7; %mm
servoLength = 22.8; %mm
servoWidth = 12.6; %mm

%segment lengths for the laser mount
A = servoHeight + servoWidth / 2; %Panning Arm Length (mm)
B = 33; %Base of Tilt Platform Length (mm)
C = 33; %Tilt Arm Length (mm)
D = 200; %Distance of Base of Tilt Platform to Wall (mm)

figure;
%test for tilt angle calculation
for i = 0:10:130
    tilt = calcTilt(A, B, C, D, [0, i]); %find tilt angle
    plotLaser(tilt, 0, A, B, C, D) %plot the laser postion of a grid
    pause(0.1);
end

%% Rotation Matrices Definitions
%rotate around x axis
function mat = xRot(theta)
mat=[1 0 0
    0 cosd(theta) sind(theta)
    0 -sind(theta) cosd(theta)];
end

%rotate around y axis
function mat = yRot(theta)
mat=[cosd(theta) 0 -sind(theta)
    0 1 0 
    sind(theta) 0 cosd(theta)];
end

%rotate around z axis
function mat = zRot(theta)
mat=[cosd(theta) sind(theta) 0
    -sind(theta) cosd(theta) 0
    0 0 1];
end

%calculate the tilt of the laser mount to hit a specific point
function tilt = calcTilt(A, B, C, D, commandPosition)
    E = commandPosition(1, 2) - A; %find the vertical distace (on y) for the laser to hit a grid relative to where the base of the tilt arm is
    if E == A + C %if the laser need to hit parallel to the x-y plane, set the tilt angle to 90 degrees
        tilt = 90; %degrees
    else %if the laser is not parallel to the x-y plane, calculate the tilt angle 
        coeffs = [C-D, -2 * E, D + C];
        angleRoots = roots(coeffs);
        tilt = max(2 * atand(angleRoots));  %degrees
    end
end

%plot where the laser is pointing
function plotLaser(tilt, pan, A, B, C, D)
    panAngle = pan; %degrees
    tiltAngle = 180 - tilt; %degrees
    
    %find the length of the laser to the wall
    if tilt == 90
        laserLength = D;
    else
        laserLength = ((D + C / cosd(tilt)) / sind(tilt) - C * tand(tilt));
    end

    RL = xRot(-90); %set the rotation of the laser relative to the tilt arm to be perpendicular
    RT = xRot(tiltAngle); %find the local rotation of the tilt arm around the x axis
    RB = xRot(-90); %set the angle of the base of the tilt arm to be perpendicular to the pan arm
    RP = zRot(panAngle); %find the local (also global) rotation of the pan arm around the z axis

    panPos = RP \ [0; 0; A;]; %find the new end point position of the pan arm
    basePos = (RB * RP) \ [0; 0; B]; %find the new, untranslated position of the base of the tilt arm
    basePos = basePos + panPos; %translate the base of the tilt arm to the correct location
    tiltPos = (RT * RB * RP) \ [0; 0; C]; %find the new end point of the tilt arm before it is translated
    tiltPos = tiltPos + basePos; %translate the tilt arm to the correct global location
    laserPos = (RL * RT * RB * RP) \ [0; 0; laserLength]; %find the untranslated position of the laser
    laserPos = laserPos + tiltPos; %translate the laser to the correct, global position

    mount = [[0; 0; 0], panPos, basePos, tiltPos]; %combine all of the points of the laser mount into a matrix
    laser = [tiltPos, laserPos]; %combine the start and end points of the laser

    plot3(mount(1,:), mount(2,:), mount(3,:), 'k', 'LineWidth', 3);%plot the laser mount in black
    hold on;
    xlim([-66, 66]);
    ylim([-66, D + C]);
    zlim([0, 66 * 2]);

    xlabel('X');
    ylabel('Y');
    zlabel('Z');

    for i = 0 : 10 : 140
      plot3([-66, 66], [D + C, D + C], [i, i], 'b');
      plot3([i - 70, i - 70], [D + C, D + C], [0, 132], 'b'); 
    end
    
    %plot the laser in red
    plot3([laser(1, 1),laser(1, 2)], [laser(2, 1), laser(2, 2)], [laser(3, 1),laser(3, 2)], 'r', 'LineWidth', 2);
    hold off;
end