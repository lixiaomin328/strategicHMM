%save choice data to fixation infos
GAZE_FOLDER = '../../gaze_data/';
userFolders = dir(GAZE_FOLDER);
PROJECT_NAME = {'matching', 'seeking', 'hiding','highhiding','highseeking'};
for i = 1:length(userFolders)
    userName = userFolders(i).name;
    if userName(1) =='.'
        continue;
    end
    for projectId = 1:5
        for subId = 1:2
            fprintf('userName = %s, project Id: %d, sub Id: %d \n', ...
                userName, projectId, subId);
            appendChoiceSalToFixation(PROJECT_NAME{projectId},subId,userName);
            
        end
    end
end