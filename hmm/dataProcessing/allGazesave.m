DATA_FOLDER = '../../data/';
userFolders = dir(DATA_FOLDER);
IMG_FOLDER = '../../res/';
PROJECT_NAME = {'matching', 'seeking', 'hiding','highhiding','highseeking'};
for i = 9%3:4%25:length(userFolders)
    userName = userFolders(i).name;
    if userName(1) =='.' 
        continue;
    end
    for projectId = 3%1:5 
        %imgFiles = dir([IMG_FOLDER, PROJECT_NAME{projectId},'/*.jpg']);
        for subId = 1:2
         imgFiles = dir([IMG_FOLDER, PROJECT_NAME{projectId},'/',num2str(subId),'/*.jpg']);
    for imgId = 1:length(imgFiles)
        fprintf('userName = %s, project Id: %d, sub Id: %d, imgId: %d\n', ...
           userName, projectId, subId, imgId);
         salienceDataProcessing(userName, projectId, subId, imgId)
    end
        end
    end
end