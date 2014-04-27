function [ im_list ] = ListDirImages(im_dir)
%LISTDIRIMAGES gets a list of all the image files in the given directory
%   taken from code for montage.m
    D = dir(im_dir); % read the files
    n = 0;
    im_list = cell(size(D));
    for a=1:numel(D)
        if numel(D(a).name)>4 && ~D(a).isdir ...
            && (any(strcmpi(D(a).name(end-3:end), {'.png', '.tif', '.jpg', '.bmp', '.ppm', '.pgm', '.pbm', '.gif', '.ras'})) ...
            || any(strcmpi(D(a).name(end-4:end), {'.tiff', '.jpeg'})))
                    n = n + 1;
        im_list{n} = D(a).name;
        end
    end
    im_list = im_list(1:n);
end