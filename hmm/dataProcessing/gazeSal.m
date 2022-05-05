function  gazeSalience =gazeSal(userName,gamename,subsession,imageId) 
addpath('/Volumes/My Passport/sa1/gbvs')

% gamename = 'seeking';
% subsession = 1;
% imageId = 6;
% userName = 'xinyan';
IMG_FOLDER = '../../res/';
%DATA_FOLDER = '../../data/';
GAZE_FOLDER = '../../gaze_data/';
POINT_DATA_ID = [1,9,10,22,23];%%Column that correspond to useful data field
VALID_CHECK_ID = [15,28]; %%whether the data is valid or not
RESOLUTION = [1080, 1920];
convolutor = 0.1*ones(10,1);
% [-1,-1,-1,2,3,4,6,7,8,9,10,12,13,-1,14];
%% Rank salience
images = dir([IMG_FOLDER, gamename,'/*.jpg']);
dImage = imread([IMG_FOLDER,'/',gamename,'/',images(imageId).name]);
cImage = imresize(dImage,RESOLUTION);
saliency = gbvs(cImage);
newSalvalue = saliency.master_map_resized; 

%% Gaze time
load([GAZE_FOLDER,userName, '/', userName,'_',gamename,'_',num2str(subsession), '_',images(imageId).name(1:end-4), '.mat']);
if isempty(gazeData)
    gazeSalience=[];
    return
end
validGazePoints = gazeData(sum(gazeData(:,VALID_CHECK_ID),2) == 0, POINT_DATA_ID); %#ok<NODEF>
validGazePoints(validGazePoints < 0) = 0.00001;
%validGazePoints(validGazePoints > 1) = 1;
validGazePoints=validGazePoints(round(length(validGazePoints)/10):length(validGazePoints)/5*4,:);

[height, width,~] = size(cImage);
validGazePoints2D = ceil([mean(validGazePoints(:,[2,4]),2)*width,  height * mean(validGazePoints(:,[3,5]),2)]);


gazeSalience = zeros(length(validGazePoints2D),1);
for i = 1 :length(validGazePoints2D)
    gazeSalience(i,1) = newSalvalue(min(validGazePoints2D(i,2),height),min(validGazePoints2D(i,1),width));
end
plot((validGazePoints((length(convolutor)):end,1)-validGazePoints(1,1))/1e6,conv(gazeSalience,convolutor,'valid'),'linewidth',2)
%relTime = validGazePoints((length(convolutor)):end,1)-validGazePoints(1,1);
title('Salience of gaze over time ')
xlabel('time')
ylabel('salience index')
