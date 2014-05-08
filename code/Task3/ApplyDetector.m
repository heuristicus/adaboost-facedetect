function sc = ApplyDetector(Cparams, ii_im)
%APPLYDETECTOR Apply the strong classifier features defined by Cparams 
% to the given image and computing the response of each feature for the
% image.

fmat = Cparams.fmat;
req_features = fmat(:, Cparams.thetas(:,1));
thetas = Cparams.thetas(:,2);
parities = Cparams.thetas(:,3);
alphas = Cparams.alphas;
fscores = ii_im(:)' * req_features;

% Apply the weak classifiers to get a classification of an image
% first need to apply parities in order to get the correct classification
% direction
partheta = parities .* thetas;
parscores = parities .* fscores';

% if correctly classified, the weight of the weak classifier is added to
% the score of this image.
cvalue = alphas .* (parscores < partheta);
sc = sum(cvalue);

end

