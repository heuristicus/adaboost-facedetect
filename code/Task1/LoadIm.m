function [im, ii_im] = LoadIm(im_fname)
    im = double(imread(im_fname));
    imstd = std(im(:));
    if (imstd == 0)
        imstd = 1;
    end
    im = (im-mean(im(:)))/imstd;
    ii_im = cumsum(cumsum(im,1),2);
end