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
1. In the user input section, set ModifyFootEvents to 0. When you have determined that foot events should be added, set it to 1. 
2. Change saveFile to wherever you want to save the file. 
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
