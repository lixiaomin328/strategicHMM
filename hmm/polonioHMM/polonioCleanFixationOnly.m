%%Polonio fixationDataOnly
keySet = {'other_1','other_2','other_3','other_4','own_1','own_2','own_3','own_4','start','row_1','row_2'};
valueSet = [5 6 7 8 1 2 3 4 9 9 10];%start is 9 and end is 10
M = containers.Map(keySet,valueSet);

dataRaw = readtable('polonioProcessedMULTI.csv');
subjects = unique(dataRaw.sbj);
fixationAll = {};
gameNumbers = unique(dataRaw.game);
for i = 1:length(subjects)
    subId = subjects(i);
    for gameNum = min(gameNumbers):min(gameNumbers)+15
        dataPersonGame = dataRaw(dataRaw.sbj==subId&dataRaw.game ==gameNum,:);
        trials = unique(dataPersonGame.trial_index);
        for trial = 1:length(trials)
            trialId = trials(trial);
            dataTrial = dataPersonGame(dataPersonGame.trial_index==trialId,:);
            fixationTrial =[];
            for fixation = 2:length(dataTrial.AOI)
                fixationTrial = [fixationTrial;M(dataTrial.AOI{fixation})];
            end
            fixationAll = [fixationAll,[fixationTrial;M(dataTrial.Response{1})]];
        end
    end

    
end

    fixationAll = fixationAll';
save('polonioGaze_MULTI.mat','fixationAll')
