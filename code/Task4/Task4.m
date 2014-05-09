%% Task 4
% Face Detection by Sub-Windows in a larger image
load('data/Cparams10ftr.mat');
im=imread('data/TrainingImages/FACES/face00001.bmp');
W=19;
H=19;
% Display score using normalized Features
dets = ScanImageFixedSize(Cparams, im, W, H);
% Display score using LoadIm
[~, ii_im] = LoadIm('data/TrainingImages/FACES/face00001.bmp');
score = ApplyDetector(Cparams, ii_im)

%% Load 
im =imread('data/TestImages/one_chris.png');
W=19;
H=19;
dets = ScanImageFixedSize(Cparams, im, W, H);
%%
im =imread('data/TestImages/one_chris.png');
DisplayDetections(im, dets)
