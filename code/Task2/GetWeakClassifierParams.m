function [ weights, fs, class ] = GetWeakClassifierParams( ii_imF, ii_imN, fVec )
%GETWEAKCLASSIFIERPARAMS 
fsFace=ii_imF*fVec;
fsNonF=ii_imN*fVec;
fs=[fsFace;fsNonF];
weights=ones(size(fs,1),1)/size(fs,1);
class=[ones(size(fsFace,1),1); zeros(size(fsNonF,1),1)];
end

