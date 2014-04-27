% loading test image
filename = 'data/TrainingImages/FACES/face00001.bmp';
[im, ii_im] = LoadIm(filename);
imagesc(im)
colormap gray
close all

y=3;
x=3;
w=3;
h=3;
A = ComputeBoxSum(ii_im, x, y, w, h)

B=sum(sum(im(y:y+h-1, x:x+w-1)))
%% Testing the various feature types
f1 = FeatureTypeI(ii_im, x, y, w, h);
f1man = sum(sum(im(y:y+h-1, x:x+w-1))) - sum(sum(im(y+h:y+2*h-1, x:x+w-1)));

f2 = FeatureTypeII(ii_im, x, y, w, h);
f2man = sum(sum(im(y:y+h-1, x+w:x+2*w-1))) - sum(sum(im(y:y+h-1, x:x+w-1)));

f3 = FeatureTypeIII(ii_im, x, y, w, h);
f3man = sum(sum(im(y:y+h-1, x+w:x+2*w-1))) - sum(sum(im(y:y+h-1, x+2*w:x+3*w-1)))...
        - sum(sum(im(y:y+h-1, x:x+w-1)));

f4 = FeatureTypeIV(ii_im, x, y, w, h);
f4man = sum(sum(im(y:y+h-1, x+w:x+2*w-1))) + sum(sum(im(y+h:y+2*h-1, x:x+w-1)))...
        - sum(sum(im(y:y+h-1, x:x+w-1))) - sum(sum(im(y+h:y+2*h-1, x+w:x+2*w-1)));

fprintf(GetSeparator())    
fprintf('Testing feature computation functions against manual computation...\n')    
    
func = [f1 f2 f3 f4];
manual = [f1man f2man f3man f4man];
diff = ones(1,4);
eps_err = ones(1,4);
for i=1:4
    f = func(i);
    man = manual(i);
    diff(i) = f-man;
    eps_err(i) = diff(i) > eps;
    fprintf('FeatureType: %d\n', i)
    fprintf('Function computes: %f\n', f)
    fprintf('Manual computation: %f\n', man)
    fprintf('Difference: %e, and < eps?: %d\n', diff(i), eps_err(i))
end

for i=1:4
    if (eps_err(i) ~= 0)
        fprintf('ERROR: Feature type %d does not match! Difference: %e\n', i, diff(i))
    end
end

if (sum(eps_err) == 0)
    fprintf('All feature computations worked OK!\n')
else
    fprintf('ERRORS IN FEATURE COMPUTATION!\n')
end


%% test the feature computation functions against the debugging data
dinfo2 = load('data/DebugInfo/debuginfo2.mat');
x = dinfo2.x; y = dinfo2.y; w = dinfo2.w; h = dinfo2.h;
f1diff = dinfo2.f1 - FeatureTypeI(ii_im, x, y, w, h);
f2diff = dinfo2.f2 - FeatureTypeII(ii_im, x, y, w, h);
f3diff = dinfo2.f3 - FeatureTypeIII(ii_im, x, y, w, h);
f4diff = dinfo2.f4 - FeatureTypeIV(ii_im, x, y, w, h);

eps_err = ones(1,4);
eps_err(1) = abs(f1diff) > eps;
eps_err(2) = abs(f2diff) > eps;
eps_err(3) = abs(f3diff) > eps;
eps_err(4) = abs(f4diff) > eps;

fprintf(GetSeparator())
fprintf('Testing feature computation functions against debug data...\n')
for i=1:4
    if (eps_err(i) ~= 0)
        fprintf('ERROR: Feature type %d does not match! Difference: %e\n', i, diff(i))
    end
end

if (sum(eps_err) == 0)
    fprintf('All feature computations worked OK!\n')
else
    fprintf('ERRORS IN FEATURE COMPUTATION!\n')
end

 %% Test enumeration of all features
 tic
 a= EnumAllFeatures(19,19);
 toc

 %% test loading multiple images
 LoadImages('data/TrainingImages/FACES', 100)
 
%% test computing features
ntests = 100;
ii_ims = LoadImages('data/TrainingImages/FACES', ntests);
dinfo3 = load('data/DebugInfo/debuginfo3.mat');
ftype = dinfo3.ftype;
fs = ComputeFeature(ii_ims, ftype);
nerr = sum(abs(dinfo3.fs - fs) > eps);
errors = dinfo3.fs - fs;

fprintf(GetSeparator())
fprintf('Testing feature computation on multiple images\n')

if (nerr > 0)
    fprintf('ERROR: %d errors made out of %d.\n', nerr, ntests)
    fprintf('Max error: %e, min error: %e\n', max(errors), min(errors))
else
    fprintf('All features computed successfully!\n')
end
