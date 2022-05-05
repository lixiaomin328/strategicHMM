# strategicHMM
software: matlab
package for estimation:
HMM toolbox for matlab

For installation and reference:
https://www.cs.ubc.ca/~murphyk/Software/HMM/hmm.html

eyeMMV-master for fixation extraction: 
https://github.com/krasvas/EyeMMV/blob/master/README.txt

behavioral data: data/

gaze_data raw: gaze_data/
Raw data has 27 fields, many of them are redundant. Need to refer to script for detailed reference.

fixation data: fixation/

Fixation locations after filtering through the fixation extraction algorithm EyeMMV.
There are two kinds of extractions, t2 and 3s. See EyeMMV for further reference about the difference. We are using t2 for now. The first two columns refers to the 2D coordinates on the screen of fixation center. The screen size is always 1080*1920. The fifth column and sixth refers to the starting time and ending time for a fixation. Fixation durations can be calculated accordingly.

gaze data in fixation and salience format: fixationSal/

Salience values of each fixation. (this is the input of the HMM model)
fixSalience.m transform fixation location data above to fixation salience data as well as fixation duration. 

For all four kinds of data, each folder is one subject with denominated id, say 1_hiding_1_6.mat is data for the first subject, hiding game, no feedback, image 6. All the IDs are consistent among three folders. 

There are also aggregated data regardless of individuals in hmmSourceWithRT/game/allData.mat

All processing scripts for image game are in hmm/dataProcessing/
key scripts: For model estimation. hmmEstimation.m, hmmEstimationChoicev.m 
for model estimation with fixation duration:
hmmCTModel.m

Trained model will be saved to hmmGazeResults/ (you can also change the dir in the scripts above).

There are also simulation code for trained model:
simulateDecisionOverTime.m for continuous model.

For level estimation using HMM:
individualLevel.m to estimate individual levels.
HMMwithLevelk.m main scripts to estimate per trial level.

For polonio's matrix game is in hmm/polonioHMM

Polonio raw data: polonio1.csv and polonio2.csv in the main folder.

preprocessing code for polonio dataset: polonioPreprocessing.m for separating different types of games.

Main code: polonioEstimate.m

Visualization code: visualizeHiddenStates.m to generate pictures on game matrix.



