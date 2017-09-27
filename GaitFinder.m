function [FootEventCell, RightStancePhase, LeftStancePhase, RightSwingPhase, LeftSwingPhase]=GaitFinder(FootEventCell, trajectories, vicon, S)
% Get stance phase and swing phase at relevant times.
set(0,'DefaultFigureWindowStyle','docked')
close all
%{

A                   B                  C        D                 E
----------------------------------------        -------------------
|                   |                  |        |                 |
|        3          |        2         |        |         1       |
|                   |                  |        |                 |
----------------------------------------        -------------------
F                   G                  H        I                 J

                                        X
                                        |
                                        |
                                        |
                                        |
                                        |
                                        |
                                        |
                    ____________________|Y

A=LFHD
B=RFHD
C=LBHD
D=RBHD
E=C7
F=T10
G=CLAV
H=STRN
I=RBAK
J=LSHO

%}
%
% clear
% load('TKA_01_WALK_S_05.mat')
% clc
close all
plotFP=0;
%% Putting in potentially useful parts to FootEventCell
[events,~]=size(FootEventCell);
FootEventCell=FEvExtras(FootEventCell, events);


%Locations of Markers (including in Z direction)
AX=391.966;
AY=1204.19;
AZ=7.84858;
BX=395.548;
BY=605.055;
BZ=7.5632;
CX=399.388;
CY=3.07798;
CZ=4.75386;
DX=404.686;
DY=-495.021;
DZ=4.22262;
EX=406.302;
EY=-1094.14;
EZ=2.81809;
FX=-3.08097;
FY=1200.51;
FZ=11.2397;
GX=-1.68692;
GY=600.406;
GZ=10.9616;
HX=2.47279;
HY=4.13384;
HZ=8.26937;
IX=6.42704;
IY=-500.798;
IZ=6.95139;
JX=9.29651;
JY=-1097.86;
JZ=5.23778;

%Rectangle Coordinates

xv3=[AY BY GY FY AY];
yv3=[AX BX GX FX AX];

xv2=[GY BY CY HY GY];
yv2=[GX BX CX HX GX];

xv1=[IY DY EY JY IY];
yv1=[IX DX EX JX IX];
%% Check for foot events and if they are on a forceplate
try
    FootEventCell=FootFPInfo(plotFP, FootEventCell, trajectories, events, xv1, yv1, xv2,yv2, xv3, yv3, S, vicon);
catch
    RightStancePhase=[];
    LeftStancePhase=[];
    RightSwingPhase=[];
    LeftSwingPhase=[];
    return
end
%Separate FootEventCell into Left and Right Events on Good FP Events
[RightStancePhase, LeftStancePhase, LeftFootEvent, RightFootEvent]=StancePhase(FootEventCell, events);
if isempty(RightStancePhase) || sum(RightStancePhase(1,:))<1
    warning('No proper foot events found for right stance phase.')
    RightStancePhase=[];
    
end
if isempty(LeftStancePhase) || sum(LeftStancePhase(1,:))<1
    warning('No proper foot events found for left stance phase.')
    LeftStancePhase=[];
end

%Find the next heel strike and mark it as swing phase
[RightSwingPhase, LeftSwingPhase]=SwingPhase(FootEventCell, RightStancePhase,LeftStancePhase);
if length(RightStancePhase)>1
    RightStancePhase(:,4)=[];
end
if length(LeftStancePhase)>1
    LeftStancePhase(:,4)=[];
end

% Check Data "Goodness" off Several Criteria
% DataGoodness( RightStancePhase, LeftStancePhase, LeftFootEvent, RightFootEvent, vicon )