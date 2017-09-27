function [ plate ] = inFP( Direction, Event,TrajectoryCell, xv1, yv1, xv2, yv2, xv3, yv3)
%Finds if the foot is over the forceplate.

TC=TrajectoryCell;
vicon=ViconNexus();
[ deviceNumbers, ~, ~, ~ ] = ForcePlateNum(vicon);

%What plates are used? (0 must be included by default)
deviceNumbers(isnan(deviceNumbers))=[];
platesUsed=[0 deviceNumbers];
switch Direction
    case 'Right'
        switch Event
            case 'FS'
                [in1HFSR,~] = inpolygon(TC{14},TC{13},xv1,yv1);
                [in2HFSR,~] = inpolygon(TC{14},TC{13},xv2,yv2);
                [in3HFSR,~] = inpolygon(TC{14},TC{13},xv3,yv3);
                
                [in1TFSR,~] = inpolygon(TC{16},TC{15},xv1,yv1);
                [in2TFSR,~] = inpolygon(TC{16},TC{15},xv2,yv2);
                [in3TFSR,~] = inpolygon(TC{16},TC{15},xv3,yv3);
                
                
                if in1HFSR && in1TFSR > 0
                    plate=1;
                elseif in2HFSR && in2TFSR > 0
                    plate=2;
                elseif in3HFSR && in3TFSR > 0
                    plate=3;
                else
                    plate=0;
                end
                
            case 'FO'
                [in1HFOR,~] = inpolygon(TC{6},TC{5},xv1,yv1);
                [in2HFOR,~] = inpolygon(TC{6},TC{5},xv2,yv2);
                [in3HFOR,~] = inpolygon(TC{6},TC{5},xv3,yv3);
                
                [in1TFOR,~] = inpolygon(TC{8},TC{7},xv1,yv1);
                [in2TFOR,~] = inpolygon(TC{8},TC{7},xv2,yv2);
                [in3TFOR,~] = inpolygon(TC{8},TC{7},xv3,yv3);
                
                if in1HFOR && in1TFOR > 0
                    plate=1;
                elseif in2HFOR && in2TFOR > 0
                    plate=2;
                elseif in3HFOR && in3TFOR > 0
                    plate=3;
                else
                    plate=0;
                end
                
        end
    case 'Left'
        switch Event
            case 'FS'
                [in1HFSL,~] = inpolygon(TC{10},TC{9},xv1,yv1);
                [in2HFSL,~] = inpolygon(TC{10},TC{9},xv2,yv2);
                [in3HFSL,~] = inpolygon(TC{10},TC{9},xv3,yv3);
                
                [in1TFSL,~] = inpolygon(TC{12},TC{11},xv1,yv1);
                [in2TFSL,~] = inpolygon(TC{12},TC{11},xv2,yv2);
                [in3TFSL,~] = inpolygon(TC{12},TC{11},xv3,yv3);
                
                if in1HFSL && in1TFSL > 0
                    plate=1;
                elseif in2HFSL && in2TFSL > 0
                    plate=2;
                elseif in3HFSL && in3TFSL > 0
                    plate=3;
                else
                    plate=0;
                end
                
            case 'FO'
                [in1HFOL,~] = inpolygon(TC{2},TC{1},xv1,yv1);
                [in2HFOL,~] = inpolygon(TC{2},TC{1},xv2,yv2);
                [in3HFOL,~] = inpolygon(TC{2},TC{1},xv3,yv3);
                
                [in1TFOL,~] = inpolygon(TC{4},TC{3},xv1,yv1);
                [in2TFOL,~] = inpolygon(TC{4},TC{3},xv2,yv2);
                [in3TFOL,~] = inpolygon(TC{4},TC{3},xv3,yv3);
                
                if in1HFOL && in1TFOL > 0
                    plate=1;
                elseif in2HFOL && in2TFOL > 0
                    plate=2;
                elseif in3HFOL && in3TFOL > 0
                    plate=3;
                else
                    plate=0;
                end
        end
end
%If the plate where the foot is was not used in the trial, set the plate to
%0
if ~any(plate==platesUsed)
    plate=0;
end
end