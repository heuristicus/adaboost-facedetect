function Cparams = BoostingAlg(Fdata, NFdata, FTdata, T)
%BOOSTINGALG 
fmat=FTdata.fmat;
all_ftypes=FTdata.all_ftypes; % nfeatures x 5
ii_imsFace=Fdata.ii_ims; % nimages x W*H
ii_imsNonF=NFdata.ii_ims;

% Define the number of face and non-face images. These determine which of
% the labels are positive or negative examples.
Flength=size(ii_imsFace,1);
Nlength=size(ii_imsNonF,1);

% Define the weights for each image in the training set
weights=ones(Flength+Nlength,1);
% weights = weights*(1/sum(weights));
weights(1:Nlength)=1/(2*Nlength);
weights(Nlength+1:end)=1/(2*Flength);

% The labels for each training image are defined by whether they come from
% the face or non-face data. Face data is positive.
labels=[zeros(Nlength,1);ones(Flength,1)];

% Predefine the vectors used to store the parameters which are computed by
% each weak classifier. Their length corresponds to the number of features
% being used.
theta = zeros(1,size(all_ftypes,1));
p = zeros(1,size(all_ftypes,1));
error = zeros(1,size(all_ftypes,1));

% The parameters which are computed by the optimal weak classifier in each
% iteration.
Cparams.alphas = zeros(T,1);
Cparams.thetas = zeros(T,3);

% Combine the integral image matrices of the non-face and face images into
% a single one to allow for easier computation of the feature vector.
ii_imComb = [ii_imsNonF; ii_imsFace];

for t=1:T
    tic
    fprintf('Choosing weak classifier %d\n', t)
    % normalise the weights
    weights=weights/sum(weights);
    % compute a weak classifier for all the features and store the
    % separating line, the parity and the error.
    for j = 1:size(all_ftypes,1)
        fs=ii_imComb*fmat(:,j); % get the value of the feature for each training sample
        [theta(j), p(j), error(j)]=LearnWeakClassifier(weights, fs, labels);
    end
    [error_t, min_index] = min(error); % we want the feature with the minimum error
    % save the values returned by the weak classifier into the parameters
    % so that we can retrieve them later
    Cparams.thetas(t,:) = [min_index, theta(min_index), p(min_index)];
    % compute weightings for the classifiers (alphas) and a modifier for
    % the weights in order to update them (beta)
    beta = error_t/(1-error_t);
    betavec = ones(size(labels)) * beta;
    Cparams.alphas(t) = log(1/beta);
    
    % recompute the classification for the optimal feature for this loop
    fVec=fmat(:,min_index);
    fs=ii_imComb*fVec;
    % p defines which direction the positive or negative classification is
    % going
    classification=p(min_index)*fs<p(min_index)*theta(min_index);
    % recompute the weights by reducing the weight of the correctly
    % classified weights. When the weights are normalised this means that
    % the misclassified examples end up with relatively higher weights.
    weights = weights .* (betavec .^(1-abs(classification-labels)));
    time=toc;
    fprintf('Time taken: %f\n', time);
end


end
