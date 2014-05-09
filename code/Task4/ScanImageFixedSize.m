function dets = ScanImageFixedSize(Cparams, im)
if size(im,3)==3
    im = rgb2gray(im);
end
squareIm = im.*im;
ii_im = cumsum(cumsum(im,1),2);
ii_squareIm = cumsum(cumsum(squareIm,1),2);

end