function dets = ScanImageOverScale(Cparams, im, min_s, max_s, step_s)
%SCANIMAGEOVERSCALE 

dets = [];
for scale=min_s:step_s:max_s
    tic
    img = imresize(im, scale);
    dets = [dets; ScanImageFixedSize(Cparams, img, 19, 19) / scale];
    fprintf('Time taken for scale %f: %f\n', scale, toc)
end

end

