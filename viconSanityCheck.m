function [ validated ] = viconSanityCheck( TrialName, vicon )
%viconSanityCheck performs checks to validate processing
validated = 1;
nameInfo = strsplit(TrialName,'_');
switch nameInfo{3}
    case 'VRPerception'
        [~,shoulderExists] = vicon.GetModelOutput(vicon.GetSubjectNames{1}, 'RShoulderAngles');
        if any(shoulderExists)
            validated = 1;
        else
            error('No shoulder angles detected')
        end
end
end

