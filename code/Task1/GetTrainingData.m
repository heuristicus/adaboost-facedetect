function GetTrainingData(all_ftypes, np, nn)
%GETTRAININGDATA 

LoadSaveImData('data/TrainingImages/FACES', np, 'data/FaceData.mat')
LoadSaveImData('data/TrainingImages/NFACES', nn, 'data/NonFaceData.mat')

ComputeSaveFData(all_ftypes, 'data/FeaturesToUse.mat')

end

