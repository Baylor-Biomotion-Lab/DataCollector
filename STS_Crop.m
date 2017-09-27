% Find when the subject is standing in a sit-to-stand exercise based on:
% a. Force Threshold
% b. Right and Left Knee angles

% figure(1)
% plot(ModelOutputHelp.Var3{15,1}(:,end), 'r')
% plot(ModelOutputHelp.Var3{14,1}(:,end), 'b')

%Directions
x=1; y=2; z=3;
direction=x;

clf
figure(1)
hold on
plot(ModelOutput{14}(:,direction),'b') %Left Knee Angles
plot(ModelOutput{15}(:,direction),'r') %Right Knee Angles

%First, determine if the feet are in the forceplate. 
