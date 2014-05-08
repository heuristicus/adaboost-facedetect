%% Compute Histogram of feature responses
fNumber=998;
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

fpic = MakeFeaturePic([4, 5, 5, 5, 5], 19, 19);
figure
imagesc(fpic)
colormap('gray')

all_ftypes = FTdata.all_ftypes;
cpic = MakeClassifierPic(all_ftypes, [5192, 12765], [1.8725,1.467],[1,-1],19,19);
figure
imagesc(cpic)
colormap('gray')

%% compute a weak classifier for all of the features and see which has the 
% lowest error

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

[ weights, fs, class ] = GetWeakClassifierParams(ii_ims, Nii_ims, fVec);

[theta, p, err] = LearnWeakClassifier(weights, fs, class)
%% Debug 1
% check the results of the boosting algorithm

dinfo6 = load('data/DebugInfo/debuginfo6.mat');
T = dinfo6.T;
Tempdata = FTdata;
Tempdata.all_ftypes = FTdata.all_ftypes(1:1000,:);
Cparams = BoostingAlg(Fdata, NFdata, Tempdata, T);
sum(abs(dinfo6.alphas - Cparams.alphas)>eps('single'))
sum(abs(dinfo6.Thetas(:) - Cparams.thetas(:))>eps('single'))

% ourtheta=Cparams.thetas(:)
% theirtheta=dinfo6.Thetas(:)
% ouralpha = Cparams.alphas
% theiralpha = dinfo6.alphas
% thetadiff = Cparams.thetas(:) - dinfo6.Thetas(:)
% alphadiff = Cparams.alphas - dinfo6.alphas

%% testing first feature from the debug set
T = 1;
Cparams = BoostingAlg(Fdata, NFdata, FTdata, T);
figure
fpic = MakeFeaturePic(FTdata.all_ftypes(Cparams.thetas(i, 1),:), 19, 19);
imagesc(fpic)
colormap('gray')

%% Debug 2

dinfo7 = load('DebugInfo/debuginfo7.mat');
T = dinfo7.T;
Cparams = BoostingAlg(Fdata, NFdata, FTdata, T);
sum(abs(dinfo7.alphas - Cparams.alphas)>eps('single'))
sum(abs(dinfo7.Thetas(:) - Cparams.thetas(:))>eps('single'))

%save('data/Cparams10ftr.mat','Cparams')

for i=1:T
    figure
    fpic = MakeFeaturePic(FTdata.all_ftypes(Cparams.thetas(i, 1),:), 19, 19);
    imagesc(fpic)
    colormap('gray')
end

figure
cpic = MakeClassifierPic(FTdata.all_ftypes, Cparams.thetas(:, 1), Cparams.alphas, Cparams.thetas(:,3), 19, 19);
imagesc(cpic)
colormap('gray')