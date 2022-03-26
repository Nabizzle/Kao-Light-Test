clc;
clear;
close all;

%position for the laser
commandPosition = [0, 40];
mode = 2; %mode for the code. 1 = debug, 2 = find all angles in a defined grid, 3 = show one laser location.

%define a grid to be used if mode = 2;
gridXLength = 640; %mm
gridZLength = 160; %mm
resolution = gridXLength / (sqrt(400 / (gridXLength / gridZLength)) * (gridXLength / gridZLength)); %mm

%reference values for the tower pro 9g micro servo
servoHeight = 26.7; %mm
servoLength = 22.8; %mm
servoWidth = 12.6; %mm

%segment lengths for the laser mount
A = servoHeight + servoWidth / 2; %Panning Arm Length (mm)
B = 33; %Base of Tilt Platform Length (mm)
C = 33; %Tilt Arm Length (mm)
distToWall = 100; %Distance of Base of Tilt Platform to Wall (mm)

switch mode
    case 1 %debug. test for ability of laser to hit a grid of points
        fig = figure;
        fig.Position(1:2) = fig.Position(1:2) - 600;
        fig.Position(3:4) = fig.Position(3:4) * 2;
        for i = distToWall: -10 : 0
            for j = distToWall / 2 : -10 : -distToWall / 2
                commandPosition = [j, i]; %set the command position
                [pan, D] = calcPan(B, distToWall, commandPosition); %find the pan angle and the distance of the base of the tilt platform to the wall
                tilt = calcTilt(A, C, D, commandPosition); %find tilt angle
                plotLaser(tilt, pan, A, B, C, distToWall, fig); %plot the laser postion of a grid
            end
        end
    case 2 %find angles in a set grid
        gridTilt = NaN(round(gridZLength/resolution), round(gridXLength/resolution));
        gridPan = NaN(1, round(gridXLength/resolution));
        rowCount = 1;
        colCount = 1;
        for i = gridZLength-resolution : -resolution : 0
            for j = (gridXLength-resolution) / 2 : -resolution : -(gridXLength-resolution) / 2
                commandPosition = [j, i]; %set the command position
                [pan, D] = calcPan(B, distToWall, commandPosition); %find the pan angle and the distance of the base of the tilt platform to the wall
                tilt = calcTilt(A, C, D, commandPosition); %find tilt angle

                gridTilt(rowCount, colCount) = tilt;
                if rowCount == 1
                    gridPan(colCount) = pan;
                end
                colCount = colCount + 1;
            end
            colCount = 1;
            rowCount = rowCount + 1;
        end

        [CalculatedHitsX, CalculatedHitsZ] = testCalc(gridTilt, gridPan, A, B, C, distToWall);
    case 3 %find and show the laser hit location of a specific command location.
        fig = figure;
        [pan, D] = calcPan(B, distToWall, commandPosition); %find the pan angle and the distance of the base of the tilt platform to the wall
        tilt = calcTilt(A, C, D, commandPosition); %find tilt angle
        plotLaser(tilt, pan, A, B, C, distToWall, fig); %plot the laser postion of a grid
    otherwise
        error('Incorrect Mode Selected')
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

%% functions to find the correct angles for a desired laser hit location
%calculate the pan angle
function [pan, D] = calcPan(B, distToWall, commandPosition)
    pan = atand(commandPosition(1,1) / distToWall);
    D = distToWall / cosd(pan) - B;%Distance of Base of Tilt Platform to Wall (mm)
end

%calculate the tilt of the laser mount to hit a specific point
function tilt = calcTilt(A, C, D, commandPosition)
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
function plotLaser(tilt, pan, A, B, C, distToWall, fig)
    [mount, laser] = applyRotation(tilt, pan, A, B, C, distToWall);

    figure(fig);

    mountPlot = plot3(mount(1,:), mount(2,:), mount(3,:), 'k', 'LineWidth', 3);%plot the laser mount in black
    hold on;
    xlim([-100, 100]);
    ylim([-(B + C), distToWall]);
    zlim([0, 200]);

    xlabel('X');
    ylabel('Y');
    zlabel('Z');

    for i = 0 : 10 : 200
      plot3([-100, 100], [distToWall, distToWall], [i, i], 'b');
      plot3([i - 100, i - 100], [distToWall, distToWall], [0, 200], 'b');
    end

    %plot the laser in red
    laserPlot = plot3([laser(1, 1), laser(1, 2)], [laser(2, 1), laser(2, 2)], [laser(3, 1), laser(3, 2)], 'r', 'LineWidth', 2);
    laserHit = plot3(laser(1, 2), laser(2, 2), laser(3, 2), 'ro', 'LineWidth', 2);
    drawnow;
    hold off;
end

function [laserX, laserZ] = testCalc(gridTilt, gridPan, A, B, C, distToWall)
    laserX = NaN(size(gridTilt, 1), size(gridPan, 2));
    laserZ = NaN(size(gridTilt, 1), size(gridPan, 2));
    for i = 1 : size(gridTilt, 1)
        for j = 1 : size(gridPan, 2)
            tilt = gridTilt(i, j);
            pan = gridPan(j);
            [mount, laser] = applyRotation(tilt, pan, A, B, C, distToWall);

            laserX(i, j) = laser(1, 2); %keeps trace of where the laser is hitting the target
            laserZ(i, j) = laser(3, 2); %keeps trace of where the laser is hitting the target
        end
    end
end

function [mount, laser] = applyRotation(tilt, pan, A, B, C, distToWall)
    panAngle = pan; %degrees
    tiltAngle = 180 - tilt; %degrees
    D = distToWall / cosd(pan) - B;%Distance of Base of Tilt Platform to Wall (mm)

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

    panPos = [0; 0; A;]; %find the new end point position of the pan arm
    basePos = (RB * RP) \ [0; 0; B]; %find the new, untranslated position of the base of the tilt arm
    basePos = basePos + panPos; %translate the base of the tilt arm to the correct location
    tiltPos = (RT * RB * RP) \ [0; 0; C]; %find the new end point of the tilt arm before it is translated
    tiltPos = tiltPos + basePos; %translate the tilt arm to the correct global location
    laserPos = (RL * RT * RB * RP) \ [0; 0; laserLength]; %find the untranslated position of the laser
    laserPos = laserPos + tiltPos; %translate the laser to the correct, global position

    mount = [[0; 0; 0], panPos, basePos, tiltPos]; %combine all of the points of the laser mount into a matrix
    laser = [tiltPos, laserPos]; %combine the start and end points of the laser
end
