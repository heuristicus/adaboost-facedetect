function [ii_ims] = LoadImages(im_dir, nims, vectorise)
% LoadImages load a number of images from the given directory. Assume that
% all images are of the same size. The function returns a cell array
% containing the images. If the vectorise parameter is nonzero, then
% instead of a cell array the function will return the images in a matrix
% where each row is one image.
    


ims = ListDirImages(im_dir);

if (nims == 0)
    nims = numel(ims);
end

if (vectorise)
    [~,first] = LoadIm(strcat(im_dir, '/', ims{1}));
    ii_ims = zeros(nims, numel(first));
    ii_ims(1,:) = first(:)';
    
    for i=2:nims
        [~, im] = LoadIm(strcat(im_dir, '/', ims{i}));
        ii_ims(i,:) = im(:)';
    end
    
else
    ii_ims = cell(nims,1);
    
    for i=1:nims
        [~,ii_ims{i}] = LoadIm(strcat(im_dir, '/', ims{i}));
    end
end
end