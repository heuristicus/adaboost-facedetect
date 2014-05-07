%% Compute Histogram of feature responses
fNumber=15000;
Fdata = load('data/FaceData.mat');
NFdata = load('data/NonFaceData.mat');
FTdata = load('data/FeaturesToUse.mat');
fmat=FTdata.fmat;
Nii_ims=NFdata.ii_ims;
ii_ims=Fdata.ii_ims;
fVec=fmat(:, fNumber);
Nfs=Nii_ims*fVec;
fs=ii_ims*fVec;
[Nelem,Ncenter]=hist(Nfs);
[elem,center]=hist(fs);
Nhist=Nelem./sum(Nelem);
Fhist=elem./sum(elem);



%% Testing Weak Classifier Initial Parameters
% Run previous section to test
[ weights, fs, class ] = GetWeakClassifierParams(ii_ims, Nii_ims, fVec);

[theta, p, err] = LearnWeakClassifier(weights, fs, class)
close all
figure
hold on
plot(Ncenter,Nhist,'b');
plot(center,Fhist,'r');
line([theta,theta],[0,max(Nhist)], 'color', 'k');
title('fVec ',fNumber);
hold off

%% Plot feature types

fpic = MakeFeaturePic([1, 5, 5, 5, 5], 19, 19);
imagesc(fpic)
colormap('gray')

all_ftypes = FTdata.all_ftypes;
cpic = MakeClassifierPic(all_ftypes, [5192, 12765], [1.8725,1.467],[1,-1],19,19);
imagesc(cpic)
colormap('gray')

