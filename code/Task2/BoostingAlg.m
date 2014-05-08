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
ii_imFaces = [ii_imsNonF; ii_imsFace];

for t=1:T
    tic
    fprintf('Choosing weak classifier %d\n', t)
    weights=weights/sum(weights);
    for j = 1:size(all_ftypes,1)
        j
        fVec=fmat(:,j);
        fs=ii_imFaces*fVec;
        [theta(j), p(j), error(j)]=LearnWeakClassifier(weights, fs, labels);
    end
    [error_t, min_index] = min(error);
    Cparams.thetas(t,:) = [min_index, theta(min_index), p(min_index)];
    beta = error_t/(1-error_t);
    betavec = ones(size(labels)) * beta;
    Cparams.alphas(t) = log(1/beta);
    
    fVec=fmat(:,min_index);
    fs=ii_imFaces*fVec;
    classification=p(min_index)*fs<p(min_index)*theta(min_index);
    weights = weights .* (betavec .^(1-abs(classification-labels)));
    time=toc;
    fprintf('Time taken: %f\n', time);
end


end

