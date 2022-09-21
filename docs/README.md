# Kao-Light-Test
The Kao Light Test repository involves a set of scripts and an app used to analyze a subjects ownership of their peripersonal space. In order to do this, the experimenter selects positions for a laser to shine at various distances along or past the subject's arm. The subject is asked to react to the presence of the light as fast as possible by pressing on a foot pedal. The laser is aimed at the arm using two servos to pan and tilt the laser. The pan and tilt angles are commanded by the Grapevine NIP through 12 digital inputs (7 for 128 pan angles and 5 for 32 tilt angles.) The pan and tilt angles are centered around 90 degrees on each servo. There is also a model to calculate how the two servos should move to hit a user defined grid of points found in the [panTiltModel.m](#pantiltmodelm) script. This model can give an estimate of angles you want to use, but bear in mind that mapping to a flat grid will not be accurate to the curved surface of an arm.

 In the setup GUI, the experimenter chooses a list of pan and tilt angles for the test and the full list is repeated a user defined number of times and randomized. The servos will move at a random time before the laser shines so that the subject does not know when the laser will turn on.

# Table of Contents

* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
* [Running the Code](#running-the-code)
  * [Arduino Setup](#arduino-setup)
  * [Grapevine Setup](#grapevine-setup)
* [Running the Computational Model](#running-the-computational-model)
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
  
  Before running the full experiment on any given day, run the [footPedalDebug.m](#footpedaldebugm) to check that the foot pedal is working and the data is recording and run the [digitalOutputDebug.m](#digitaloutputdebugm) to check that the laser state indicator is recording.
  
  When starting to run the full test, open the [kaoLightTest.mlapp](kaolighttestmlapp) app which controls everything for the test. The app allows you to set pan and tilt angles that are sent to the arduino, toggle the laser on and off, sweep through the laser positions to check where on the arm the laser will be hitting, set the number of repeats of each point, and run the test.
  
  Before running the test, make sure all laser positions are visible to the subject.
  
  Also included in the repository are the Eagle files for making the shield for the Arduino that controls the servos of the laser mount.
  
  ## Prerequisites
  
  Software:
  
  * [MATLAB 2018 or later](https://www.mathworks.com/help/matlab/) (For the computational model)
  * [MATLAB 2020 or later](https://www.mathworks.com/help/matlab/) (For the MatLab app and debugging scripts)
  * [Arduino IDE](https://www.arduino.cc/en/software)
  
  Testing electronics (what is needed is based on the test)
  * Grapevine with micro D to Sub-D cable
  * [Arduino Uno](https://store-usa.arduino.cc/products/arduino-uno-rev3)
  * Arduino Uno PCB Shield
  
  ![Image of Shield Board](https://github.com/iSensTeam/Kao-Light-Test/blob/main/docs/media/Shield%20Board.png)
  ![Image of Shield Schematic](https://github.com/iSensTeam/Kao-Light-Test/blob/main/docs/media/Shield%20Schematic.png)
  
  # Running the Code
  
  ## Arduino Setup
  
  Plug in the panning servo to signal pin 10 (servo 2 on the shield) and the tilting servo to signal pin 11 (servo 1 on the shield). Make sure that the 7.8 V LiPo battery is also plugged in and check that the laser is not on automatically. If it is, you may need to adjust the shield or check that the laser connector is not touching metal. Plug in the USB cable to the Arduino to power it.
  
  Make sure to plug in the digital output cable from the Grapevine to the shield. This cable sends out the 12 bit digital signal to control for the 4096 possible angle values (128 for panning and 32 for tilting), a 13th signal to turn the laser on or off, and a fourteenth for signalling to an analog input when the laser was turned on for matching to the foot pedal data.
  
  ## Grapevine Setup
  
  Connect the foot pedal to a 5V supply or a 9 volt to a voltage regulator. Connect the foot switch so that when it is pressed, it sends a signal to the first SMA analog input. The laser indicator JST on the arduino shield to the second analog SMA input.

  # Running the Computational Model

  Open the [panTiltModel.m](#pantiltmodelm), which makes a model of how the laser could be controlled to hit a grid of points. Run this code to calculate the panning and tilting servo angles to hit this grid. The model allows you to define the size of the grid and the number of points that make up the grid. Bear in mind that while the model allows you to make an infinite grid of infinite points, the number of points actually feasible is limited by the small memory of the Arduino Uno.

  The code for the model allows for calculating the grid hits and has a debug mode that shows you an animation of the hits.
  
  # Author

  * **Nabeel Chowdhury** - Initial Creator of code and hardware.
  
  # Description of Each Script
  
  ## dataScrape.m
  This is the main data analysis script. It takes in the laser state and test angle indices to find where the tests occurred and then find the moment the foot pedal was first pressed to find a reaction time. For simplicity of data collection, it would make sense to be consistent the order of angles found, either proximal to distal or vise versa. Finally, the code outputs a figure to show the reaction times from proximal to distal on the arm.
  
  ## digitalOutputDebug.m
  This is a debug script for the laser state digital output. It starts recording for half a second, turns the laser indicator digital output on for half a second, and turns it off for half a second. Then the script outputs the recording from the second analog SMA input connection for you to verify the laser state indicator was recorded.
  
  ## footPedalDebug.m
  This is a debug script for the foot pedal. The script records through the first analog SMA input for 10 seconds and outputs the plot of the recordings live on the screen. Press the foot pedal to verify that the recording is occurring correctly.
  
  ## kaoLightTest.mlapp
  This is the main app for the test. The app has various functions described below.
  ![Image of Testing App](https://github.com/iSensTeam/Kao-Light-Test/blob/main/docs/media/Test%20App.png)
  
  The top of the app allows you to change the pan and tilt angles of the servos. Save the angles to the table next to the sliders by clicking the "Save Angle" button. When the angles are saved, the digital output is also displayed in the table for the experimenter to check. You can also select either the pan or tilt angle and edit it. When selecting an entry on the table, the servo will move to the position on that row of the table for you to check again. While an entry is selected, you can also delete it from the list with the "Delete Angle" button. Toggle the laser on or off with the laser toggle switch. When you have one or more saved angles, you can use the "Laser Sweep" button to move through all of the angles. 
  
  In the bottom of the app, there are start and stop buttons for the test to run the main experiment. This section also allows the experimenter to set the number of repeats of each angle. The main test duplicates the selected angles by the given number of repeats and randomizes the whole test array. The servos will move before the test begins and then after a 1-4 second delay, the laser will turn on. The subject then presses the foot pedal to react to the laser. The voltage across the foot pedal and the laser state digital output are recorded simultaneously. At the end of the test, the recording of the foot pedal recording, the laser state recordings, and the indices of the servo angles list is outputted to time stamped log files.
  
  ## Kao_Light_Test.ino
   The 12 digital inputs separated into a seven digit binary number for panning angles and a 5 digit binary number for tilt angles. These numbers are then converted to their base 10 equivalent and are added to an offset angle move the servos to their equivalent positions. The pan servo ranges from 27 to 154 degrees and the tilt servo ranges from 74 to 105 degrees.
  
  ## laserStateWaveScrape.m
  Takes in the laser state and targets arrays to find the times of the tests. Outputs a figure to show the found test timing as well as an array of each test time with the servo array index.
  
  ## panTiltModel.m
  Creates a computational model of the laser mount with user definable dimensions. For more information on how the model is made, refer to [this](https://github.com/iSensTeam/Kao-Light-Test/blob/main/docs/supplimentary/Modeling%20Laser%20Mount%20Pan%20and%20Tilt.pdf) supplementary document.
  The code has 3 modes: debug, finding tilt and pan angles for a grid of points, visualizing the laser hit location of a given command position.
  
  In debug mode, the laser tries to hit a square grid of points that is as wide as the gird is far away from the laser mount. The distance the mount is from the grid is user definable. The result of the laser mount hitting a 20x20 grid when 200 mm away from the grid is shown below.
  
  The finding angles mode, the user define a recangular grid of points for the model to find tile and pan angles for. This mode also outputs the expected laser hit locations for you to make sure that the code is working correctly.
  
  The final model allows you to set a command position at the top of the code and see that the model is hitting the right grid point.
  
  ![GIF of Debug Mode](https://github.com/Nabizzle/Kao-Light-Test/blob/main/docs/media/LaserTargets.gif)
