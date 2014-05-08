function DisplayFeatures(all_ftypes, Cparams, W, H)
%DISPLAYFEATURES shows the features computed by the boosting algorithm and
%their combined result given the image data.

for i=1:size(Cparams.thetas, 1)
    figure
    fpic = MakeFeaturePic(all_ftypes(Cparams.thetas(i, 1),:), W, H);
    imagesc(fpic)
    colormap('gray')
end

figure
cpic = MakeClassifierPic(all_ftypes, Cparams.thetas(:, 1), Cparams.alphas, Cparams.thetas(:,3), W, H);
imagesc(cpic)
colormap('gray')

end

