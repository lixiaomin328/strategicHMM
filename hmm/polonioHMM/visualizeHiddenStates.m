gazeCenter = [121,177;376,177;121,328;376,328;344,79;600,79;344,231;600,231];
Image = imread('sample.jpg');

for Q = 2:8
    figure()

nRow = round(Q/2);
load(['polonioHMMMULTIestimatesMEQ=',num2str(Q),'.mat'])
bestid = find(LLs==max(LLs));
obsmat = obsmats{bestid};
for nComponent = 1:size(obsmat,1)
obsmatGazeOnly = obsmat(nComponent,1:8);

obsmatGazeOnly = obsmatGazeOnly/max(obsmatGazeOnly);

heatMatrix = zeros(size(Image));
for aoiId = 1:length(obsmatGazeOnly)
    heatMatrix(gazeCenter(aoiId,2),gazeCenter(aoiId,1)) = obsmatGazeOnly(aoiId)^2;
end
H = fspecial('gaussian',100,20);
blurred = imfilter(heatMatrix,H);
gazeSaliency = blurred/max(H(:))/2;
heatMap = heatmap_overlay( Image , blurred/max(H(:))/2 );
subplot(2,nRow,nComponent)
imshow(heatMap)
title(['Hidden State ',num2str(nComponent)])
set(gca,'fontsize', 20)
end
end