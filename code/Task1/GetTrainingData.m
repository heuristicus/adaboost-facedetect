function GetTrainingData(all_ftypes, np, nn)
%GETTRAININGDATA 

LoadSaveImData('data/FACES', np, 'FaceData.mat')
LoadSaveImData('data/NFACES', nn, 'NonFaceData.mat')

ComputeSaveFData(all_ftypes, 'FeaturesToUse.mat')

end

