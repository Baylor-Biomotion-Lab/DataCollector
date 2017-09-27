function [ Names ] = NameGenerator( Subjects, Activities, Trials )
% Generates names in order to do batch analysis if necessary. 

% Instructions:
% Subjects=[1, 2, 4];
% Activities={'Bar', 'Sit', 'Walk', 'Stand'};
% Trials=[1, 2, 4, 9;
%         2, 3, 5, 9;
%         3, 4, 6, 9];
% Names=NameGenerator(Subjects, Activities, Trials);

%{
The decided naming scheme is as follows:

Subj[Subject Number]_[Activity]_TR[Trial Number].mat

For Example:

Subj1_Bar_TR01.mat

Note that there is a leading 0 for single digit numbers in accordance with
Vicon.
%}

SubjectLen=length(Subjects);
ActLen=length(Activities);
TrialLen=length(Trials(1,:));
NamesNum=SubjectLen*ActLen*TrialLen;
Names=cell(NamesNum, 1);
NameCount=1;

for Sub=1:SubjectLen
    for Act=1:ActLen
        for Trial=1:TrialLen
            TrialNum=sprintf('%02d', Trials(Sub, Trial)); %This will include leading 0s. 
            SubjectNum= sprintf('%01d',Subjects(Sub));    %This will not include leading 0s. 
            ActivityName=Activities{Act};
            FullName=sprintf('Subj%s_%s_TR%s.mat',SubjectNum, ActivityName, TrialNum);
            Names{NameCount}=FullName;
            NameCount=NameCount+1;
        end
    end
end
end

