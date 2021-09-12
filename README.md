# Kao-Light-Test
Scripts for working with the Kao Light Test Model and Hardware

# Table of Contents

* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
* [Running the Code](#running-the-code)
* [Author](#author)
* [Description of Each Script](#description-of-each-script)
  * [panTiltModel.m](#pantiltmodelm)
  
  # Getting Started
  
  As of right now, there is only the modeling code, [panTIltModel.m](#pantiltmodelm), which makes a model of how the laser is controlled. In the future, the code for controlling the Arduino Uno to tilting and panning the read laser mount will be added.
  
  Also included are the Eagle files for making the shield for the Arduino that controlls the servos of the laser mount.
  
  ## Prerequisites
  
  Software:
  
  * [MATLAB 2018 or later](https://www.mathworks.com/help/matlab/) (For the computational model and prefinding tilt and pan angles)
  * [Arduino IDE](https://www.arduino.cc/en/software)
  
  Testing electronics (what is needed is based on the test)
  * Grapevine with micro D to Sub-D cable
  * [Arduino Uno](https://store-usa.arduino.cc/products/arduino-uno-rev3)
  * Arduino Uno Shield
  
  ![Image of Shield Board](https://github.com/Nabizzle/Kao-Light-Test/blob/main/docs/media/Sheild%20Board.png)
  ![Image of Shield Schematic](https://github.com/Nabizzle/Kao-Light-Test/blob/main/docs/media/Sheild%20Schematic.png)
  
  # Running the Code
  
  When the Arduino code is added, you will need to plug in the shield and the servos and upload the Arduino code to it. You will also need to take the found tilt and pan angles for the grid size that you want and add them to the arduino code. Make sure that there are 4096 tilt values in a single row array.
  Also make sure to plug in the digital output cable from the Grapevine to the shield. This cable sends out the 12 bit digital signal to control for the 4096 angle values and a 13th signal to turn the laser on or off.
  
  # Author

  * **Nabeel Chowdhury** - Initial Creator
  
  # Description of Each Script
  
  ## panTiltModel.m
  Creates a computational model of the laser mount with user definable dimensions. For more information on how the model is made, refer to [this](https://github.com/Nabizzle/Kao-Light-Test/blob/main/docs/supplimentary/Modeling%20Laser%20Mount%20Pan%20and%20Tilt.pdf) supplimentary document.
  The code has 3 modes: debug, finding tilt and pan angles for a grid of points, visualizing the laser hit location of a given command position.
  
  In bebug mode, the laser tries to hit a square grid of points that is as wide as the gird is far away from the laser mount. The distance the mount is from the grid is user definable. The result of the laser mount hitting a 20x20 grid when 200 mm away from the grid is shown below.
  
  The finding angles mode, the user define a recangular grid of points for the model to find tile and pan angles for. This mode also outputs the expected laser hit locations for you to make sure that the code is working correctly.
  
  The final model allows you to set a command position at the top of the code and see that the model is hitting the right grid point.
  
  ![GIF of Debug Mode](https://github.com/Nabizzle/Kao-Light-Test/blob/main/docs/media/LaserTargets.gif)
