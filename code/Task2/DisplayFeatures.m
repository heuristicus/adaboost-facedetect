function DisplayFeatures(all_ftypes, Cparams, W, H, showall)
%DISPLAYFEATURES shows the features computed by the boosting algorithm and
%their combined result given the image data. Showall defines whether to
%show all of the features or just the final combined result.

for i=1:size(Cparams.thetas, 1)
    fpic = MakeFeaturePic(all_ftypes(Cparams.thetas(i, 1),:), W, H);
    if (showall)
        figure
        imagesc(fpic)
        colormap('gray')
    end
end

figure
cpic = MakeClassifierPic(all_ftypes, Cparams.thetas(:, 1), Cparams.alphas, Cparams.thetas(:,3), W, H);
imagesc(cpic)
colormap('gray')

end

