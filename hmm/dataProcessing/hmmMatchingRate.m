function allRanks = hmmMatchingRate(game,imgid,subId)
folder = '../../res/';
imgpath =  [folder, game,'/',num2str(subId)];%%'/Volumes/My Passport/sa1/res/imgsource';
resolution = [1080, 1920];
images = dir([folder, game,'/',num2str(subId),'/*.jpg']);


%%
% example of calling gbvs() with default params and then displaying result
outW = 400;
out = {};
% compute saliency maps for some images
img = imread([imgpath,'/',images(imgid).name]);
img = imresize(img,resolution);

% this is how you call gbvs
% leaving out params reset them to all default values (from
% algsrc/makeGBVSParams.m)




% show result in a pretty way

s = outW / size(img,2);
sz = size(img); sz = sz(1:2);
sz = round( sz * s );

img = imresize( img , sz , 'bicubic' );
out = lstm(images(imgid).name,resolution);
H = fspecial('gaussian',200,600);
out = imfilter(out,H);
%out = out + randn(size(out)) * 0.001;
[~,indexSal] = sort(out(:));
X = repmat([1 : size(out, 2)], [size(out,1),1]);
Y = repmat([1 : size(out, 1)], [size(out,2),1])';
allRanks = [X(indexSal),Y(indexSal)];
