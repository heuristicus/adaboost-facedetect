function LoadSaveImData(dirname, ni, im_sfn)
%LOADSAVEIMDATA Randomly chooses ni images from the given directory, loads
%them and then computes their integral images. These images are then saved
%to im_sfn

face_fnames = dir(dirname);
aa = 3:length(face_fnames);
a = randperm(length(aa));
fnums = aa(a(1:ni));

[~,first] = LoadIm(strcat(dirname, '/', face_fnames(fnums(1)).name));
ii_ims = zeros(ni, numel(first));
ii_ims(1,:) = first(:)';

for i=2:ni
    [~, im] = LoadIm(strcat(dirname, '/', face_fnames(fnums(i)).name));
    ii_ims(i,:) = im(:)';
end

save(im_sfn, 'dirname', 'fnums', 'ii_ims');

end