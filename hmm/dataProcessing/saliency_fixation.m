%function fixationSaliency()
addpath('/Volumes/My Passport/sa1/salience analysis/gbvs');
imgWidth = 1920;
imgHeight = 1080;
imgId = 14;
subId = 2;
game = 'matching';
userName = 'Diandian';
DATA_FOLDER = '../../data/';
IMG_FOLDER ='../../res/';
[a, b, c] = GazeData2DPerson(game, subId, imgId,userName);
gaze = [c, a];
[fixation_list_t2,fixation_list_3s]=fixation_detection(gaze,imgWidth/10,imgHeight/10,300,imgWidth,imgHeight);
img = visualizationImgs(gaze,fixation_list_3s,30, imgWidth, imgHeight, imgId, ['/Volumes/My Passport/sa1/res/', game,'/',num2str(subId)]);
point = clickpointPerson(game,subId,imgId,userName);
hold on;
scatter(point(1),point(2),500, 'k+','lineWidth', 5);
legend('Fixation Center','Saccade','Radius represents the duration', 'Black cross represents click position','Location','SouthEastOutside')
hold off;
saliency = gbvs(img);
sal = saliency.master_map_resized;
fixation = round(fixation_list_3s(:,1:2));
saliencyValue = zeros(size(fixation,1),1);
for i = 1:size(fixation,1)
saliencyValue(i) = sal(fixation(i,2),fixation(i,1));
end