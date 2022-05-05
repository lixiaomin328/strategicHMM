fixation_sal_folder = '../../fixationSal';
GAZE_FOLDER = '../../gaze_data/';
userFolders = dir(GAZE_FOLDER);
PROJECT_NAME = {'matching', 'seeking', 'hiding','highhiding','highseeking'};
%key variable, average level: game by person
allUserLevels = [];

for i = 1:length(userFolders)
       userLevel = [];
    for projectId = 1:3 
    userName = userFolders(i).name;
    if userName(1) =='.'
        continue;
    end
    averageLevel = individualLevel(userName,projectId);
    userLevel =[userLevel,averageLevel];
    end
    allUserLevels = [allUserLevels;userLevel];
end
%%
allUserLevels = [allUserLevels, mean(allUserLevels,2)];
allUserLevels = sortrows(allUserLevels,4);
for i = 1:3
    scatter([1:1:length(allUserLevels)],allUserLevels(:,i),'LineWidth',5)
    hold on
end