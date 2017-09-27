%% Test Zeni Method for Heel Strikes and Toe Offs
LPSI=26; RPSI=27;
LHEE=49; RHEE=74;

x=1;
direction=x;

RHS=trajectories{RPSI}{:,direction}-trajectories{RHEE}{:,direction};
figure(1)
plot(RHS)
title('Right Foot Strikes and Toe Offs')

LHS=trajectories{LPSI}{:,direction}-trajectories{LHEE}{:,direction};
figure(2)
plot(LHS)
title('Left Foot Strikes and Toe Offs')

%% Use Zeni Method but only when force plate>20
ZeniTraj=trajectories;

frames=length(trajectories{1}{:,1});

for frame=1:frames
    