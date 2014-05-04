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
 LoadImages('data/TrainingImages/FACES', 100, 0)
 
%% test computing features
ntests = 100;
ii_ims = LoadImages('data/TrainingImages/FACES', ntests, 0);
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
%% structural testing for vecboxsum
x = [1, 1, 1, 3, 4, 2, 5, 2];
y = [1, 5, 3, 1, 1, 2, 5, 3];
w = [3, 3, 4, 2, 3, 4, 2, 3];
h = [5, 2, 3, 3, 5, 2, 2, 3];

% columns are: vector index of the element, its required value, the
% corresponding value in the tmat
expected = {[17 1 35], ...
            [16 -1 34; 18 1 36], [20 -1 42; 23 1 45], ...
            [9 -1 23; 21 1 43], [17 -1 35; 35 1 65], ...
            [1 1 11; 3 -1 13; 25 -1 51; 27 1 53], ...
            [22 1 44; 24 -1 46; 34 -1 64; 36 1 66], ...
            [2 1 12; 5 -1 15; 20 -1 42; 23 1 45]};
res = zeros(1,size(expected,2));

tmat = [11 21 31 41 51 61;
        12 22 32 42 52 62;
        13 23 33 43 53 63;
        14 24 34 44 54 64;
        15 25 35 45 55 65;
        16 26 36 46 56 66];
tvec = tmat(:)';

fprintf(GetSeparator())
fprintf('Testing vectorised box computation\n')    
    
for i=1:size(x,2)
    vec = VecBoxSum(x(i), y(i), w(i), h(i), 6, 6);
    % indices of vboxsum, their values, and the corresponding values in the
    % matrix
    ind = [find(vec) vec(find(vec)) tvec(find(vec))'];
    comp = tvec * vec;
    fprintf('test %d:\n', i)
    fprintf('expected:\n')
    expected{i}
    fprintf('actual:\n')
    ind
    if (ind == expected{i})
        res(i) = 1;
    end
end

if (sum(res) == size(res,2))
    fprintf('All tests successful\n')
else
    fprintf('ERROR: %d tests failed!\n', size(res,2) - sum(res))
end

%% test vecboxsum against standard boxsum

filename = 'data/TrainingImages/FACES/face00001.bmp';
[im, ii_im] = LoadIm(filename);

ii_vec = ii_im(:)';

x = [3, 5, 10, 14, 2, 1];
y = [1, 5, 6, 9, 15, 4];
w = [10, 4, 5, 2, 15, 8];
h = [15, 3, 9, 4, 1, 2];

compvec = zeros(1, size(x,2));
compbox = zeros(1, size(x,2));

fprintf(GetSeparator())
fprintf('Testing vectorised boxsum against the standard boxsum...\n')
for i=1:size(x,2)
    compvec(i) = ii_vec * VecBoxSum(x(i), y(i), w(i), h(i), size(ii_im,2), size(ii_im,1));
    compbox(i) = ComputeBoxSum(ii_im, x(i), y(i), w(i), h(i));
end
% use single precision epsilon to avoid floating point addition errors
res = abs(compvec - compbox) < eps('single');
if (sum(res) ~= size(x,2))
    fprintf('ERROR: %d tests failed!\n', size(x,2) - sum(res))
else
    fprintf('All tests passed satisfactorily\n')
end

%% testing the computation of the vector feature against the standard features
filename = 'data/TrainingImages/FACES/face00001.bmp';
[im, ii_im] = LoadIm(filename);

ii_vec = ii_im(:)';
x = [3, 5, 10, 3, 2, 1];
y = [1, 5, 6, 9, 7, 4];
w = [5, 4, 2, 2, 5, 4];
h = [3, 3, 5, 4, 1, 2];

veccomp = zeros(1,size(x,2)*4);
origcomp = zeros(1,size(x,2)*4);

fprintf(GetSeparator())
fprintf('Testing vectorised feature computation against standard computation...\n')

for i=1:4
    for j=1:size(x,2)
        ftype = [i, x(j), y(j), w(j), h(j)];
        ftype_vec = VecFeature(ftype, 19, 19);
        veccomp((i-1)*size(x,2) + j) = ii_vec * ftype_vec;
        origcomp((i-1)*size(x,2) + j) = ComputeFeature({ii_im}, ftype);
    end
end

res = abs(veccomp - origcomp) < eps('single');
ntests = size(x,2) * 4;
if (sum(res) ~= ntests)
    fprintf('ERROR: %d tests failed!\n', size(x,2) - sum(res))
else
    fprintf('All tests passed satisfactorily\n')
end

%% testing vecallfeatures - not actual feature value computation, just vectors
fprintf(GetSeparator())
fprintf('Testing computation of multiple vectorised features.\n')


x = [3, 5, 10, 3, 2, 1];
y = [1, 5, 6, 9, 7, 4];
w = [5, 4, 2, 2, 5, 4];
h = [3, 3, 5, 4, 1, 2];

ftypes = cell(1,size(x,2)*4);
% generate some feature specifiers
for i=1:4
    for j=1:size(x,2)
        ftypes((i-1)*size(x,2)+j) = {[i, x(j), y(j), w(j), h(j)]};
    end
end

% not really a useful test, just need to make sure that the function works
VecAllFeatures(ftypes, 19,19)

%% test computing features with the vectorised method
ntests = 100;
ii_ims = LoadImages('data/TrainingImages/FACES', ntests, 0);
ii_vecs = LoadImages('data/TrainingImages/FACES', ntests, 1);
ftype = dinfo3.ftype;
fs = ComputeFeature(ii_ims, ftype);
ftype_vec = VecFeature(ftype, size(ii_ims{1},2), size(ii_ims{1},1));
vecfs = VecComputeFeature(ii_vecs, ftype_vec);
nerr = sum(abs(vecfs - fs) > eps('single'));
errors = vecfs - fs;

fprintf(GetSeparator())
fprintf('Testing feature computation on multiple images\n')

if (nerr > 0)
    fprintf('ERROR: %d errors made out of %d.\n', nerr, ntests)
    fprintf('Max error: %e, min error: %e\n', max(errors), min(errors))
else
    fprintf('All features computed successfully!\n')
end

%% test extracting features and training data and saving

imdir = 'data/TrainingImages/FACES';
nims = 100;
saveloc = 'data/tests/fext';

LoadSaveImData(imdir, nims, saveloc);

%% testing for the feature extraction and saving with actual images

% UNTESTED!!! %
dinfo4 = load('data/DebugInfo/debuginfo4.mat');
ni = dinfo4.ni;
all_ftypes = dinfo4.all_ftypes;
im_sfn = 'FaceData.mat';
f_sfn = 'FeaturesToMat.mat';
rng(dinfo4.jseed);

fprintf(GetSeparator())
fprintf('Testing multiple feature computation on a random selection of images\n')

LoadSaveImData(dirname, ni, im_sfn);
ComputeSaveFData(all_ftypes, f_sfn);

matres = abs(dinfo4.fmat - fmat) > eps('single');
imres = abs(dinfo4.ii_ims - ii_ims) > eps('single');

if (sum(matres) == 0)
    fprintf('Feature matrix computation successful.')
else
    fprintf('ERROR: %d of %d of the matrix computations failed.', sum(matres), ni)
end

if (sum(imres) == 0)
    fprintf('Integral image computations successful.')
else
    fprintf('ERROR: %d of %d of the integral image computations failed.', sum(matres), ni)
end


%% Testing getting all the training data.

% UNTESTED! %
dinfo5 = load('DebugInfo/debuginfo5.mat');
np = dinfo5.np;
nn = dinfo5.nn;
all ftypes = dinfo5.all ftypes;
rng(dinfo5.jseed);
GetTrainingData(all_ftypes, np, nn);

Fdata = load('FaceData.mat');
NFdata = load('NonFaceData.mat');
FTdata = load('FeaturesToUse.mat');

