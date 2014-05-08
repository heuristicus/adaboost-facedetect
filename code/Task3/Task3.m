%% Testing ApplyDetector

[im, ii_im] = LoadIm('data/TrainingImages/FACES/face00001.bmp');

ApplyDetector(Cparams, ii_im);

%% trying to find duplicates in data

facelist = ListDirImages(Fdata.dirname);
nonfacelist = ListDirImages(NFdata.dirname);

facetraining = Fdata.fnums;
nftraining = NFdata.fnums;

%% Testing the ROC curve 
ComputeROC(Cparams, Fdata, NFdata)