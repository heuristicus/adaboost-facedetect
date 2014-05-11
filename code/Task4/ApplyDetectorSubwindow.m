function score = ApplyDetectorSubwindow( Cparams, ii_im, stdDev, muSW )
%APPLYDETECTORSUBWINDOW Given a subwindow, compute features and normalize them.

fmat = Cparams.fmat;
req_features = fmat(:, Cparams.thetas(:,1));
thetas = Cparams.thetas(:,2);
parities = Cparams.thetas(:,3);
alphas = Cparams.alphas;
fscores = ii_im(:)' * req_features;
ftypes=Cparams.all_ftypes(Cparams.thetas(:,1),1);
ind=find(ftypes==3);

% norm=ones(size(fscores,1),1)*(1/stdDev);
% % fscores=fscores./stdDev;
% % if ~isempty(ind)
% %     fscores(ind)=fscores(ind)+((numel(ii_im)*muSW)/stdDev);
% % end

% Apply the weak classifiers to get a classification of an image
% first need to apply parities in order to get the correct classification
% direction
partheta = parities .* thetas;
parscores = parities .* fscores';

% if correctly classified, the weight of the weak classifier is added to
% the score of this image.
cvalue = alphas .* (parscores < partheta);
score = sum(cvalue);

end



