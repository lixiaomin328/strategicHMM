% function hmmForGazeSaliency
%%
projectNames = {'matching','hiding','seeking'};
for projectId = 1:length(projectNames)
game = projectNames{projectId};
%finding cutoffs
load(['hmmGazeResults/','hmmGazeResult_',game,'.mat'])
x = cutoffHMMx(muMean(1),muMean(2),sigmaMean(1),sigmaMean(2));
for i = 1:2
    if x(i)>min(muMean(1:2))&&x(i)<max(muMean(1:2))
        cutoff = x(i);
    end
end
%%
superVector = [];
superVectorTime = [];
superVectorTimeEnd = [];
%subId = 1;
userFolder = '../../fixationSal';
gazeFolder = '../../fixationSal';
GAZE_FOLDER = '../../gaze_data/';
userFiles = dir(GAZE_FOLDER);
allData = cell(2,0);
cnt = 1;
lastFixationEndRt = 100;
for i = 1 : length(userFiles)
    userName = userFiles(i).name;
    if userName(1) =='.'
        continue;
    end
    for subId = 1:2
    load([[userFolder,'/',userName,'fixationSal'], '/', userName,'_',game,'_',num2str(subId),'.mat'])
    for imgId = 1:19
        [i,imgId]
        if isempty(perGameFixSal{imgId,1})
        continue;
        end
        superVector = [superVector;100;perGameFixSal{imgId,1}];
        superVectorTime = [superVectorTime;100;perGameFixSal{imgId,2}];
        superVectorTimeEnd=[superVectorTimeEnd;100;perGameFixSal{imgId,3}];
        allData{cnt,1} = [perGameFixSal{imgId,1};100]; 
        if ~isempty(perGameFixSal{imgId,3})
            
        allData{cnt,2} = [perGameFixSal{imgId,2};perGameFixSal{imgId,3}(end)];%time
        end
        cnt = cnt +1;
    end
    end
end
% for k = 1:length(allData)
%     if isempty(allData{k,2})
%         continue
%     end
%     allData{k,1}(1:end-1) = sign(allData{k,1}(1:end-1) - cutoff);
%     allData{k,2} = allData{k,2} - allData{k,2}(1);
% end
%%
%1 for salient state
% endEntries = find(superVectorTime==100);
% endEntries = endEntries(2:end);
% superVectorTime(endEntries)= superVectorTimeEnd(endEntries-1);
% superState = superVector;
% superState(superState>cutoff&superState<50)=1;
% superState(superState<cutoff&superState<50)=0;
save(['hmmSourceWithRT/',[game,'allData']],'allData')
% 
% %%
% % write results into .csv file
% filename = ['hmmSourceWithRT/',game,'.csv'];
% fid = fopen(filename, 'w');
% for sampleId = 1 : size(allData, 1)
%     fprintf(fid, '%d,',allData{sampleId, 1});
%     fprintf(fid, '\n');
%     fprintf(fid, '%d,',allData{sampleId, 2});
%     fprintf(fid, '\n');
% end
% fclose(fid);
end