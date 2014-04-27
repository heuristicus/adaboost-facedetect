function [fs] = ComputeFeature(ii_ims, ftype)
fn = ftype(1);
x = ftype(2);
y = ftype(3);
w = ftype(4);
h = ftype(5);

if (fn > 4 || fn < 1)
    error('Error: Unknown feature type %d', ftype(1))
end

fs = zeros(1,size(ii_ims,1));

for i=1:size(ii_ims,1)
    switch fn
        case 1
            fs(i) = FeatureTypeI(ii_ims{i},x,y,w,h)
        case 2
            fs(i) = FeatureTypeII(ii_ims{i},x,y,w,h)
        case 3
            fs(i) = FeatureTypeIII(ii_ims{i},x,y,w,h)
        otherwise
            fs(i) = FeatureTypeIV(ii_ims{i},x,y,w,h)
    end
end

end