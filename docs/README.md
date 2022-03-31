# Kao-Light-Test
The Kao Light Test repository involves a set of scripts and an app used to analyze a subjects ownership of their peripersonal space. In order to do this, a laser shines at various distances along the subject's arm and the subject is asked to react to the presence of the light as fast as possible by pressing on a foot pedal. The laser is aimed at the arm using two servos to pan and tilt the laser. The calculation of how the two servos should move to hit a grid of points is done by a computational model found in the [panTiltModel.m](#pantiltmodelm) script.

During the test, the experimentor can choose the tilt angle that allows the laser to go along the arm. During the test, the laser will randomly pick pan angles that shine the laser along the arm. The servos will move at a random time before the laser shines so that the subject does not know when the laser will turn on.

# Table of Contents

* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
* [Running the Code](#running-the-code)
  * [Arduino Setup](#arduino-setup)
  * [Grapevine Setup](#grapevine-setup)
* [Author](#author)
* [Description of Each Script](#description-of-each-script)
  * [dataScrape.m](datascrapem)
  * [digitalOutputDebug.m](digitaloutputdebugm)
  * [footPedalDebug.m](footpedaldebugm)
  * [kaoLightTest.mlapp](kaolighttestmlapp)
  * [Kao_Light_Test.ino](kao_light_testino)
  * [laserDebug.ino](laserdebugino)
  * [laserStateWaveScrape.m](laserstatewavescrapemm)
  * [panTiltModel.m](#pantiltmodelm)
  
  # Getting Started
  
  Open the [panTIltModel.m](#pantiltmodelm), which makes a model of how the laser is controlled. Run this code to calculate the panning and tilting servo angles to find where the laser will hit a grid. The model allows you to define the size of the grid and the number of points that make up the grid. Bare in mind that while the model allows you to make an infinite grid of infinite points, the number of points acutally feasible is limited by the small memory of the Arduino Uno.
  
  Before running the full experiment on any given day, run the [footPedalDebug.m](#footpedaldebugm) to check that the foot pedal is working and the data is recording and run the [digitalOutputDebug.m](#digitaloutputdebugm) to check that the laser state indicator is recording.
  
  When starting to run the full test, open the [kaoLightTest.mlapp](kaolighttestmlapp) app which will allow you to set up the parameters for the test. The app allows you to recalculate the servo angles to copy over to the Arduino Uno, toggle the laser on and off, tilt and sweep the laser to check where on the arm the laser will be hitting, set the number of repeats of each point, and run the test.
  
  Before running the test, make sure the arrays of panning and tilting angles output by the app match the arrays on the Arduino Uno.
  
  Also included in the repository are the Eagle files for making the shield for the Arduino that controlls the servos of the laser mount. **Currently these files need to be updated. Refer to [issue #9](https://github.com/iSensTeam/Kao-Light-Test/issues/9).**
  
  ## Prerequisites
  
  Software:
  
  * [MATLAB 2018 or later](https://www.mathworks.com/help/matlab/) (For the computational model and prefinding tilt and pan angles)
  * [MATLAB 2020 or later](https://www.mathworks.com/help/matlab/) (For the MatLab app and debugging scripts)
  * [Arduino IDE](https://www.arduino.cc/en/software)
  
  Testing electronics (what is needed is based on the test)
  * Grapevine with micro D to Sub-D cable
  * [Arduino Uno](https://store-usa.arduino.cc/products/arduino-uno-rev3)
  * Arduino Uno Shield
  
  ![Image of Shield Board](https://github.com/iSensTeam/Kao-Light-Test/blob/main/docs/media/Sheild%20Board.png)
  ![Image of Shield Schematic](https://github.com/iSensTeam/Kao-Light-Test/blob/main/docs/media/Sheild%20Schematic.png)
  
  # Running the Code
  
  ## Arduino Setup
  
  Plug in the panning servo to signal pin 10 (servo 2 on the shield) and the tilting servo to signal pin 11 (servo 1 on the shield). Make sure the that output panning and tilitng arrays from the [kaoLightTest.mlapp](kaolighttestmlapp) match the arrays on the Arduino. If they do not, copy the angles to the arduino by saving the values as a csv and then copying and pasting the values to the arduino. **In the future, these arrays should be loaded in through the serial port or a similar method.** Make sure that the 7.8 V LiPo battery is also plugged in and check that the laser is not on automatically. If it is, you make need to adjust the sheild or check that the laser connector is not touching metal. Plug in the USB cable to the Arduino to power it.
  
  Also make sure to plug in the digital output cable from the Grapevine to the shield. This cable sends out the 12 bit digital signal to control for the 4096 angle values and a 13th signal to turn the laser on or off. It also bridges the grounds for the shield. **Note that while 4096 positions are possible, only around 400 will fit in the Arduino's memory.**
  
  ## Grapevine Setup
  
  Connect the foot pedal to a 5V supply or a 9 volt to a voltage regulator. Connect the foot switch so that when it is pressed, it sends a signal to the first SMA analog input. Connect the first digital SMA output to the second analog SMA input. 
  
  # Author

  * **Nabeel Chowdhury** - Initial Creator of code and hardware.
  
  # Description of Each Script
  
  ## dataScrape.m
  This is the main data analysis script. It takes in the laser state and servo angle indcices to find where the tests occured and then find the moment the foot pedal was first pressed to find a reaciton time. Then the code outputs a figure to show the reaction times from proximal to distal on the arm.
  
  ## digitalOutputDebug.m
  This is a debug script for the laser state digital output. It starts recording for half a second, turns the digital output on for half a second, and turns it off for half a second. Then the script outputs the recording from the second analog SMA input connection for you to verify the laser state indicator was recorded.
  
  ## footPedalDebug.m
  This is a debug script for the foot pedal. The script records through the first analog SMA input for 10 seconds and outputs the plot of the recordings live on the screen. Press the foot pedal to verfy that the recording is occuring correctly.
  
  ## kaoLightTest.mlapp
  This is the main app for the test. The app has various functions described below.
  ![Image of Testing App](https://github.com/iSensTeam/Kao-Light-Test/blob/main/docs/media/Test%20App.png)
  
  In the first box is the angle generation code. You can define the grid you want and its distance from the subject and calculate the angles for panning and tilting. The app will then ask you if you want to save out the results to the workspace. This part of the app will output where the laser will hit the grid and the panning and tilting matricies. The tilting matrix is also reshaped for you in a different variable to make it easier to copy to the arduino.
  
  In the second block, the app allows you to toggle the laser on and off, pick different tilt angles, and sweep the laser along the current tilt angle. The tilt spinner, allows you to go through each row of the tilt angle array and limits itself in the code.
  
  In the third block, the app runs the main experiment as well as allows you to set the number of repeats and stop the test. The main test diplicates the angles along the arm and randomizes the whole test array. The servos will move before the test begins and then after a 1-4 second delay, the laser will turn on. The subject then presses the foot pedal to react to the laser. The voltage across the foot pedal and the laser state digital output are recorded simultaneously. At the end of the test, the recording of the foot pedal recording, the laser state recordings, and the order of the servo angles is output to time stamped log files.
  
  ## Kao_Light_Test.ino
  The calculated panning and tilting servo angles are stored on the arduino at the beginning. **Remember that the Arduino can only really store around 400 tiliting angles.** The 12 digital inputs are then converted to their base 10 equivalent and used as an index for the tilt array. The tilt array index is also converted to an index for the panning array by taking the mod of the index by the length of the panning array. Make sure that if the grid is ever changed to recopy the newly calculated servo angles to the Arduino Uno. In the future, the servo angle arrays should be loaded to the Arduino from the MatLab app instead of manually copying and pasting the arrays. Alternativly, the digital outputs from the Grapevine could send the angle values directly.
  
  ## laserDebug.ino
  Takes in the 12 digital outputs from the Grapevine and converts it to a base 10 number output to the Serial Monitor. **Note that the digital input 0 is always high and input 1 is always low as they are used by the Serial Monitor.**
  
  ## laserStateWaveScrape.m
  Takes in the laser state and targets arrays to find the times of the tests. Outputs a figure to show the found test timeings as well as an array of each test time with the servo array index.
  
  ## panTiltModel.m
  Creates a computational model of the laser mount with user definable dimensions. For more information on how the model is made, refer to [this](https://github.com/iSensTeam/Kao-Light-Test/blob/main/docs/supplimentary/Modeling%20Laser%20Mount%20Pan%20and%20Tilt.pdf) supplimentary document.
  The code has 3 modes: debug, finding tilt and pan angles for a grid of points, visualizing the laser hit location of a given command position.
  
  In bebug mode, the laser tries to hit a square grid of points that is as wide as the gird is far away from the laser mount. The distance the mount is from the grid is user definable. The result of the laser mount hitting a 20x20 grid when 200 mm away from the grid is shown below.
  
  The finding angles mode, the user define a recangular grid of points for the model to find tile and pan angles for. This mode also outputs the expected laser hit locations for you to make sure that the code is working correctly.
  
  The final model allows you to set a command position at the top of the code and see that the model is hitting the right grid point.
  
  ![GIF of Debug Mode](https://github.com/Nabizzle/Kao-Light-Test/blob/main/docs/media/LaserTargets.gif)
