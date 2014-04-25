function [im, ii_im] = LoadIm(im_fname)
im = double(imread(im_fname));
im = (im-mean(im(:)))/(std(im(:)+0.0001));
ii_im = cumsum(cumsum(im,1),2);
end