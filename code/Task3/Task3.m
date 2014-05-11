%% Testing ApplyDetector

[im, ii_im] = LoadIm('data/TrainingImages/FACES/face00001.bmp');

ApplyDetector(Cparams, ii_im);

%% Testing the ROC curve 
ComputeROC(Cparams, Fdata, NFdata, 0.7, 0.01, 'data/testimscores.mat')