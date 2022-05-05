%%save fixation salience
function perGameFixSal = fixSalience(game,subId,userName)
addpath('/Volumes/My Passport/EyeMMV-master');
fixation_folder = '../../fixation';
fixation_sal_folder = '../../fixationSal';
resolution = [1080, 1920];
IMG_FOLDER = '../../res/';
images = dir([IMG_FOLDER, game,'/',num2str(subId),'/*.jpg']);
perGameFixSal = cell(length(images),3);
for imgId = 1:length(images)
newSalvalue = lstm(images(imgId).name,resolution);
oneDimentionSal = newSalvalue(:);
[new, rank] = sort(oneDimentionSal);
rocValue = [1:length(new)]'/length(new);
newSalvalue(rank) = rocValue;
if isempty(newSalvalue)
    return;
end
userFixCp = [[fixation_folder,'/',userName,'fixation'], '/', userName,'_',game,'_',num2str(subId), '_',num2str(imgId), '.mat'];
if ~exist(userFixCp)
    perGameFixSal{imgId,1} = [];
    perGameFixSal{imgId,2} = [];
    perGameFixSal{imgId,3} = [];
    continue;
end
load([[fixation_folder,'/',userName,'fixation'], '/', userName,'_',game,'_',num2str(subId), '_',num2str(imgId), '.mat']);
fixation_list_t2 = ceil(fixation_list_t2);
fixationDimenOne = fixation_list_t2(:,2);
fixationDimenTwo= fixation_list_t2(:,1);
fixationDimenOne(fixationDimenOne>1080) = 1080;
fixationDimenTwo(fixationDimenTwo>1920) = 1920;
fixation_sal =[];
for i = 1:size(fixation_list_t2,1)
    sal = newSalvalue(fixationDimenOne(i),fixationDimenTwo(i));
    timestampStarts = fixation_list_t2(:,5);
    
fixation_sal = [fixation_sal;sal];
end
perGameFixSal{imgId,1} = fixation_sal;
perGameFixSal{imgId,2} = timestampStarts;
perGameFixSal{imgId,3} = fixation_list_t2(:,6);
end
if ~exist([fixation_sal_folder,'/',userName,'fixationSal'])
    mkdir([fixation_sal_folder,'/',userName,'fixationSal']);
end
save([[fixation_sal_folder,'/',userName,'fixationSal'], '/', userName,'_',game,'_',num2str(subId),'.mat'],...
    'perGameFixSal')