function dets = ScanImageOverScale(Cparams, im, min_s, max_s, step_s)
%SCANIMAGEOVERSCALE 

dets = [];
for scale=min_s:step_s:max_s
    img = imresize(im, scale);
    dets = [dets; ScanImageFixedSize(Cparams, img, 19, 19) / scale];
end

end

