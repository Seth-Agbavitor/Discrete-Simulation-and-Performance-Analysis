function [fire, transition] = COMMON_PRE(transition)

switch transition.name
    case 'tQualityVerification' 
        random_num = rand; % Generate a random number between 0 and 1
        granted = requestSR({'rQualityVerification',1});
        
        % Determine whether the quality is 'AQuality' or 'BQuality'
        if (granted)
            if random_num < 0.95
                color = 'AQuality'; 
            else
                color = 'BQuality';
            end
            transition.new_color = color;
            fire = granted; % Assign the value of granted to fire
        else
            fire = 0;
        end
        
    case 'tDisposePoorQuality'
        % Check for 'BQuality' tokens and decide whether to fire
        tokID1 = tokenAnyColor('pQualityConfirmed',1, {'BQuality'});
        fire = tokID1;
        
    case 'tTransferConfirmedQuality'
        % Check for 'AQuality' tokens and decide whether to fire
        tokID2 = tokenAnyColor('pQualityConfirmed',1,{'AQuality'});
        fire = tokID2;
        
    case {'tMaterialCutting', 'tSeaming', 'tSoleAttachment','tEyeletFixing', 'tLaceInsertion', 'tDesignImprinting', ...
          'tSizeNumbering','tSortingMatching',   'tCleaning', ...
          'tPackagingStage',}
        % General case for various transitions
        resourceName = ['r', transition.name(2:end)]; % Create resource name
        granted = requestSR({resourceName, 2});
        if (granted)
            fire = granted;
        else
            fire = 0;
        end
        
    otherwise 
        fire = 1; % Default case to fire the transition
end
