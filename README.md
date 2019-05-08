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
To find out how to incorporate DataCollector into the full Vicon workflow, see the lab's SOP Section 6. 

A .mat file will be saved in the same directory as saveFile.
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
## Variables Generated
I want to say that, when looking at the variables, there are a lot of either redundant or useful variables. Unfortunately this project was started without a lot of planning and that is an unfortunate outcome. However, the DataCollector available currently should be able to get you most if not all of the information you need.

| Variable Name  | Function |
| ------------- | ------------- |
| ```Accelerations```  | Marker accelerations in (x,y,z)  |
| ```EMGProcessed```  | NaN  |
| ```EMGTable```  | Raw EMG signals  |
| ```FootEventCell```  | Toe offs/Foot strikes and when/where they happened  |
| ```FootEventStruct```  | Redundant ```FootEventCell```  |
| ```ForcePlateData```  | Self explanatory  |
| ```FPD```  | Cell version of ```ForcePlateData``` which is easier to access |
| ```LeftStancePhase```  | When and where the left stance phase occurred, where the third column has the force plate number  |
| ```LeftStride```  | Self explanatory (see left stance phase) |
| ```LeftSwingPhase```  | Self explanatory (see left stance phase)  |
| ```Marker Names```  | List of all names of markers. The index of the marker name corresponds to ```trajectories```, etc.  |
| ```ModelOutput```  | Contains kinematic information  |
| ```ModelOutputHelp```  | Also contains kinematic information, but adds on marker names  |
| ```RightStancePhase```  | Self explanatory (see left stance phase)  |
| ```RightStride``` | Self explanatory (see left stance phase)  |
| ```RightSwingPhase```  | Self explanatory (see left stance phase) |
| ```S```  | Subject name. Commonly used to interface with Vicon  |
| ```saveFile```  | Where the .mat file will be saved  |
| ```SubjectParams```  | Subject information such as height, weight, etc.  |
| ```trajectories```  | Marker trajectories in (x,y,z)  |
| ```TrialInfo```  | Useful misc. info about the trial such as frame rates  |
| ```TrialName``` | Self explanatory  |
| ```velocities```  | Marker velocities in (x,y,z)  |
| ```vicon```  | A class generated when interfacing with Vicon Nexus  |

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
We could then plot this, find the range of motion, etc. 

# Troubleshooting DataCollector
#### A popup box told me that it wasn't on the path? 
Add all of the files to MATLAB's search path. Read more about this [here](https://www.mathworks.com/help/matlab/matlab_env/what-is-the-matlab-search-path.html). This probably means you need to get a little bit more experience in MATLAB. 

#### I got an error that says ```Error using cd```?
Change the variable ```safeFile``` to a directory on your computer that exists. 

#### I want to get X variable from Vicon?
In order to learn more about the interface between MATLAB and Vicon, type ```doc ViconNexus``` into the command window. This should bring up a help file which contains information pertaining to getting more information from Vicon Nexus.
