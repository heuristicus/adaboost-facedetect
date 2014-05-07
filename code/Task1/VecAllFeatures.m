function [fmat] = VecAllFeatures(all_ftypes, W, H)
%VECALLFEATURES Create a matrix where each column is a vector which can be
%used to compute a feature. all_ftypes should be a cell array containing
%the features that are to be computed. It should be a row vector.

fmat = zeros(W*H, size(all_ftypes,1));
for i=1:size(fmat,2)
    fmat(:,i) = VecFeature(all_ftypes(i,:), W, H);
end

