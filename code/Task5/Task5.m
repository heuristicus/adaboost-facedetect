%% Load all of the relevant bits of data and then learn a strong classifier with 100 weak ones
close all;
Fdata = load('data/FaceData.mat');
NFdata = load('data/NonFaceData.mat');
FTdata = load('data/FeaturesToUse.mat');

% convert the fmat to a sparse matrix in order to
% speed up the multiplications needed when doing feature computations
FTdata.fmat = sparse(FTdata.fmat);

T = 100;

Cparams.thetaCparams = BoostingAlg(Fdata, NFdata, FTdata, T);

% compute the ROC curve and get the threshold for the true positive rate
Cparams.thresh = ComputeROC(Cparams, Fdata, NFdata, 0.7, 0.01,'data/100testscores.mat');

save('data/Cparams100cl.mat','Cparams')

%% Display the final classifier that is a result of the combined features
close all;
FTdata = load('data/FeaturesToUse.mat');
load('data/Cparams100cl.mat')

DisplayFeatures(FTdata.all_ftypes, Cparams, 19, 19, 0)

%% try 100 features on chris
close all
% im =imread('data/TestImages/big_one_chris.png');
im = imread('data/TestImages/IMG_0190.jpg');
load('data/Cparams100cl.mat')
min_s = 0.1;
max_s = 0.4;
step_s = 0.05;
dets = ScanImageOverScale(Cparams, im, min_s, max_s, step_s);
DisplayDetections(im, dets)
DisplayDetections(im, PruneDetections(dets, 0.7))

%% testing scaling stuff
% im =imread('data/TestImages/big_one_chris.png');
im = imread('data/TestImages/IMG_0190.jpg');
ims = rgb2gray(im);
ims = imresize(ims, 0.1);
figure
imagesc(ims)
axis equal
colormap('gray')

%% Find faces in all of the test images
close all;
Fdata = load('data/FaceData.mat');
NFdata = load('data/NonFaceData.mat');
FTdata = load('data/FeaturesToUse.mat');
load('data/Cparams10ftr.mat')

files = dir('data/TestImages');
files = files(3:end);
min_s = 0.1;
max_s = 0.4;
step_s = 0.05;
detected = cell(length(files), 1);
for i=1:length(files)
    fprintf('-------------------------------------------\n')
    fprintf('Image %d, %s\n', i, files(i).name)
    files(i).name
    im = imread(files(i).name);
    detected{i} = ScanImageOverScale(Cparams, im, min_s, max_s, step_s);
    DisplayDetections(im, detected{i})
    fprintf('Detected:\n')
    detected
end

%% display images with pruned faces
load('data/detectedfaces.mat')

for i=1:length(files)
    DisplayDetections(imread(files(i).name), PruneDetections(detected{i}, 0.3))
end
