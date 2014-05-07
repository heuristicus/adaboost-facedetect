function cpic = MakeClassifierPic(all_ftypes, chosen_f, alphas, ps, W, H)
%MAKECLASSIFIERPIC 

cpic=zeros(H,W);

for i=1:numel(chosen_f)
    cpic=cpic+MakeFeaturePic(all_ftypes(chosen_f(i),:), W, H)*alphas(i)*ps(i);
end

end

