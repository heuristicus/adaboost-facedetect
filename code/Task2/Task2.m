%% Compute Histogram of feature responses

Fdata = load('data/FaceData.mat');
NFdata = load('data/NonFaceData.mat');
FTdata = load('data/FeaturesToUse.mat');
fmat=FTdata.fmat;
Nii_ims=NFdata.ii_ims;
ii_ims=Fdata.ii_ims;
fVec=fmat(:, 12028);
Nfs=Nii_ims*fVec;
fs=ii_ims*fVec;
[Nelem,Ncenter]=hist(Nfs);
[elem,center]=hist(fs);
Nhist=Nelem./sum(Nelem);
Fhist=elem./sum(elem);
close all
figure
hold on
plot(Ncenter,Nhist,'b');
plot(center,Fhist,'r');
hold off

%% Testing Weak Classifier Initial Parameters
% Run previous section to test
[ weights, fs, class ] = GetWeakClassifierParams(ii_ims, Nii_ims, fVec);