%%Polonio fixationDataOnly
keySet = {'other_1','other_2','other_3','other_4','own_1','own_2','own_3','own_4','start'};
valueSet = [5 6 7 8 1 2 3 4 9];%start is 9 and end is 10
M = containers.Map(keySet,valueSet);

dataRaw = readtable('polonioProcessed.csv');
subjects = unique(dataRaw.sbj);
fixationAll = {};
for i = 1:length(subjects)
    subId = subjects(i);
    for gameNum = 1:16
        dataPersonGame = dataRaw(dataRaw.sbj==subId&dataRaw.game ==gameNum,:);
        trials = unique(dataPersonGame.trial_index);
        for trial = 1:length(trials)
            trialId = trials(trial);
            dataTrial = dataPersonGame(dataPersonGame.trial_index==trialId,:);
            fixationTrial =[];
            for fixation = 2:length(dataTrial.AOI)
                fixationTrial = [fixationTrial;M(dataTrial.AOI{fixation})];
            end
            fixationAll = [fixationAll,[fixationTrial;9]];
        end
    end

    
end

    fixationAll = fixationAll';
save('polonioGazeDSS.mat','fixationAll')
