%save all fixation infos
GAZE_FOLDER = '../../gaze_data/';
userFolders = dir(GAZE_FOLDER);
IMG_FOLDER = '../../res/';
PROJECT_NAME = {'matching', 'seeking', 'hiding','highhiding','highseeking'};
for i = 1:length(userFolders)
    userName = userFolders(i).name;
    if userName(1) =='.' 
        continue;
    end
    for projectId = 1:5 
        for subId = 1:2
         imgFiles = dir([IMG_FOLDER, PROJECT_NAME{projectId},'/',num2str(subId),'/*.jpg']);
    for imgId = 1:length(imgFiles)
        fprintf('userName = %s, project Id: %d, sub Id: %d, imgId: %d\n', ...
           userName, projectId, subId, imgId);
         fixationProcess(PROJECT_NAME{projectId},subId,imgId,userName)
    end
        end
    end
end