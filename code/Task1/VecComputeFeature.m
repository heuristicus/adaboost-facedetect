function [fs] = VecComputeFeature(ii_ims, ftype_vec)
%VECCOMPUTEFEATURE Computes a feature for all the given images 
% using the vectorised method, returning a column vector containing each
% value

size(ii_ims)
size(ftype_vec)

fs = (ii_ims * ftype_vec)';

end

