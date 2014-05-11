%% Load all of the relevant bits of data
Fdata = load('data/FaceData.mat');
NFdata = load('data/NonFaceData.mat');
FTdata = load('data/FeaturesToUse.mat');

% convert the fmat to a sparse matrix in order to
% speed up the multiplications needed when doing feature computations
FTdata.fmat = sparse(FTdata.fmat);

T = 100;

Cparams = BoostingAlg(Fdata, NFdata, FTdata, T);

save('data/Cparams100cl.mat','Cparams')