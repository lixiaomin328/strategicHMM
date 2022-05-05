function appendChoiceSalToFixation(game,subId,userName)
addpath('/Users/xiaominli/Dropbox/salience_2016+/method/code/DataProcessing')
fixation_sal_folder = '../../fixationSal';
user_folder = '../../fixation';
resolution = [1080, 1920];
IMG_FOLDER = '../../res/';
images = dir([IMG_FOLDER, game,'/',num2str(subId),'/*.jpg']);
DATA_FOLDER = '../../data';

%getUserData
load([[fixation_sal_folder,'/',userName,'fixationSal'], '/', userName,'_',game,'_',num2str(subId),'.mat'],...
    'perGameFixSal')
for imgId = 1:length(images)
    %%get image sal matrix
    newSalvalue = lstm(images(imgId).name,resolution);
    oneDimentionSal = newSalvalue(:);
    [new, rank] = sort(oneDimentionSal);
    rocValue = [1:length(new)]'/length(new);
    newSalvalue(rank) = rocValue;
    if isempty(newSalvalue)
        return;
    end
    
    
    
    %%get click point
    point= clickpointPerson(game,subId,imgId,userName,DATA_FOLDER);
    if isempty(point)
        perGameFixSal{imgId,4}= -1;
        continue;
    end
    
    point = ceil(point);
    choiceSal= newSalvalue(point(1,2),point(1,1));
    perGameFixSal{imgId,4}=choiceSal;
end
save([[fixation_sal_folder,'/',userName,'fixationSal'], '/', userName,'_',game,'_',num2str(subId),'.mat'],...
    'perGameFixSal')






