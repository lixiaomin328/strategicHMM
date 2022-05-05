%only getting multiple equilibria games
fileName = '../../polonio1.csv';
data = readtable(fileName);
%only getting games from 32 to 48
data.game= str2double(data.game);
data.RT = str2double(data.RT);

newData = data(data.game<33&data.game>16,:);
writetable(newData,'shPolonio1_MULTI.csv');
