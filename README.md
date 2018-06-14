          _____                    _____                    _____                  
         /\    \                  /\    \                  /\    \                 
        /::\____\                /::\    \                /::\    \                
       /:::/    /               /::::\    \              /::::\    \               
      /:::/    /               /::::::\    \            /::::::\    \              
     /:::/    /               /:::/\:::\    \          /:::/\:::\    \             
    /:::/____/               /:::/__\:::\    \        /:::/  \:::\    \            
    |::|    |               /::::\   \:::\    \      /:::/    \:::\    \           
    |::|    |     _____    /::::::\   \:::\    \    /:::/    / \:::\    \          
    |::|    |    /\    \  /:::/\:::\   \:::\    \  /:::/    /   \:::\    \         
    |::|    |   /::\____\/:::/  \:::\   \:::\____\/:::/____/     \:::\____\        
    |::|    |  /:::/    /\::/    \:::\  /:::/    /\:::\    \      \::/    /        
    |::|    | /:::/    /  \/____/ \:::\/:::/    /  \:::\    \      \/____/         
    |::|____|/:::/    /            \::::::/    /    \:::\    \                     
    |:::::::::::/    /              \::::/    /      \:::\    \                    
    \::::::::::/____/               /:::/    /        \:::\    \                   
     ~~~~~~~~~~                    /:::/    /          \:::\    \                  
                                  /:::/    /            \:::\    \                 
                                 /:::/    /              \:::\____\                
                                 \::/    /                \::/    /                
                                  \/____/                  \/____/           
                                  
# DataCollector
MATLAB software for importing Vicon biomotion data.
# Getting Up and Running
## Before Using Vicon:
1. In the user input section, set ```ModifyFootEvents``` to 0. When you have determined that foot events should be added, set it to 1. 
2. Change ```saveFile``` to wherever you want to save the file. 
## When Using Vicon:
1. In Vicon Nexus 2.6.x, set up a new pipeline. 
   * If there is a DataCollector pipeline, do not create a new pipeline. 
   * Ensure that the pipeline is marked as "private" to avoid errors. 
2. Add the following operations to the pipeline:
   * Autocorrelate Events
   * Detect Events From Forceplate
   * Run MatLab Operation
     * In the Properties section of the operation, set "Matlab script file: " to the location of the DataCollector.m script.
3. Process data as usual. 
4. Run the DataCollector pipeline. 

A .mat file will be saved in the same directory as saveFile (get it?).
# File Directory
## Main Files
The main script is called DataCollector.m. All functions are called by this script, and any debugging should start here. The rest are the primary functions which call any subfunctions to accomplish their tasks. 
* DataCollector.m - The main script which calls all functions to gather and organize raw data from Vicon Nexus for later processing. 
* ForcePlateInfo.m - Gets forceplate info. This is lab specific- i.e. the forceplates have a unique identifier which I have used to find out which forceplates are active and which are not. 
* GetEMGData.m - Gathers raw EMG data if it is available. Also processes data if desired. 
* TrajectoryInfo.m - X,Y,Z coordinates of markers. 
* GetFootEvents.m - Finds when there are heel strikes and toe offs. 
* GaitFinder.m - Uses the foot events to assign frame numbers to stance phase and swing phase.

## Auxiliary Files
Files which serve a useful purpose, but do not contribute *as much* to the main gathering/processing of data. 
* UserFootEvents.m - Is activated by setting ModifyFootEvents = 1 in the DataCollector script. Allows user to manually input values for foot events that Vicon did not detect.

# Utilizing Data from VAC DataCollector
Data from DataCollector is saved as a .mat file and uses the same name as the trial name in Vicon. It contains nearly all the output data from Vicon.
## Kinematics
Kinematic data is found in ModelOutputHelp, which is data type table. Column 2 has all of the model outputs from Vicon (hip angles, knee moments, etc.). Model outputs from Vicon will change from file to file depending on a number of variables, so you'll have to find what row corresponds to what variable. 
For example, if we wanted to find right hip angles we would type:
```
varNo = find(strcmp(ModelOutputHelp{:,2}, 'RHipAngles'));
```
Then we will use this to access this row and grab the flexion angles:
```
RHipFlexion = (ModelOutputHelp{varNo,3}{1}(:,1))
```
This is a bit complicated, so I've written a helper function to make it easier to perform. It will also auto-plot the data for you. If I wanted to plot it using the helper function I would type:
```
hipData = prettyPlots('trial','R_Subj10_Free_335_TR02','whole','RHipAngles','x',0);
```
It would generate the following figure:
![alt text](https://github.com/Baylor-Biomotion-Lab/Images/blob/master/hip%20flexion.png "Example Flexion")
Information for the prettyPlots function can be found by typing:
```
help prettyPlots
```
into the command window. Note I will expect you to be able to use this on all functions you write and use that are considered "finalized". One last thing to note is that the data for kinematics is a matrix inside of a cell inside of a table. Definitely not the most ideal way to access the data. Anyway the data in the matrix is stored in 3 columns. Column 1 is generally flexion/extension, column 2 is ad/abduction, and column 3 is internal/external rotation. 
