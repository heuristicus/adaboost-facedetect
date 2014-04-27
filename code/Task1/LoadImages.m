function [ii_ims] = LoadImages(im_dir, nims)
% LoadImages load a number of images from the given directory. Assume that
% all images are of the same size. The function returns a cell array
% containing the images.
    
    ims = ListDirImages(im_dir);
    ii_ims = cell(nims,1);

    for i=1:nims
        [~,ii_ims{i}] = LoadIm(strcat(im_dir, '/', ims{i}));
    end
    
end

