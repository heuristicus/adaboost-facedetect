function Cparams = BoostingAlg(Fdata, NFdata, FTdata, T)
%BOOSTINGALG 
fmat=FTdata.fmat;
all_ftypes=FTdata.all_ftypes;
ii_imsFace=Fdata.ii_ims;
ii_imsNonF=NFdata.ii_ims;
Flength=size(ii_imsFace,1);
Nlength=size(ii_imsNonF,1);
weights=zeros(Flength+Nlength,1);
weights(1:Nlength)=1/(2*Nlength);
weights(Nlength:end)=1/(2*Flength);
labels=[zeros(Nlength,1);ones(Flength,1)];
theta = zeros(1,size(all_ftypes,1));
p = zeros(1,size(all_ftypes,1));
error = zeros(1,size(all_ftypes,1));
Cparams.alphas = zeros(T,1);
Cparams.thetas = zeros(T,3);
ii_imFaces = [ii_imsNonF, ii_imsFace];
for t=1:T
    weights=weights/sum(weights);
    for j = 1:size(all_ftypes,1)
        fVec=fmat(:,j);
        fs=ii_imFaces*fVec;
        [theta(j), p(j), error(j)]=LearnWeakClassifier(weights, fs, labels);
    end
    [error_t, min_index] = min(error);
    Cparams.thetas(t,:) = [min_index, theta(min_index), p(min_index)];
    beta = error_t/(1-error_t);
    Cparams.alphas(t) = log(1/beta);
        
    
    fVec=fmat(:,min_index);
    fs=ii_imFaces*fVec;
    classification=p(min_index)*fs<p(min_index)*theta;
    weights = weights * beta^(1-abs(classification-labels))
end


end

