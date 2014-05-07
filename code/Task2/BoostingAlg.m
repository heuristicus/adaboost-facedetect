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

for t=1:T
    weights=weights/sum(weights);
    fVec=fmat(:,j)
    fs=ii_imsFace*fVec
    LearnWeakClassifier(weights, fs, class);
    
end


end

