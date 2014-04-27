function [fs] = ComputeFeature(ii_ims, ftype)

fn = ftype(1);

if (fn > 4 || fn < 1)
    error('Error: Unknown feature type %d', ftype(1))
end

% convert to cell array so that we can pass the vector as comma separated
% parameters
fcell = num2cell(ftype(2:end));
% define function cell array so we can call a different function based on
% the feature type we want
features = {@(im, ftr)(FeatureTypeI(im,fcell{:})),...
     @(im, ftr)(FeatureTypeII(im,fcell{:})),...
     @(im, ftr)(FeatureTypeIII(im,fcell{:})),...
     @(im, ftr)(FeatureTypeIV(im,fcell{:}))};
% one number for each image
fs = zeros(1,size(ii_ims,1));

for i=1:size(ii_ims,1) 
    fs(i) = features{fn}(ii_ims{i}, ftype);
end

end