filename = 'C:\Users\Einar\Dropbox\DD2427-project\TrainingImages\FACES/face00001.bmp';
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


%% Feature type I
f = FeatureTypeI(ii_im, x, y, w, h)
f1 = sum(sum(im(y:y+h-1, x:x+w-1)))-sum(sum(im(y+h:y+2*h-1, x:x+w-1)))

%% Feature type II
f = FeatureTypeII(ii_im, x, y, w, h)
f2 = sum(sum(im(y:y+h-1, x+w:x+2*w-1)))-sum(sum(im(y:y+h-1, x:x+w-1)))

%% Feature type III
f = FeatureTypeIII(ii_im, x, y, w, h)
f3 = sum(sum(im(y:y+h-1, x+w:x+2*w-1)))-sum(sum(im(y:y+h-1, x+2*w:x+3*w-1)))-sum(sum(im(y:y+h-1, x:x+w-1)))

%% Feature type IV
f = FeatureTypeIV(ii_im, x, y, w, h)
f4 = sum(sum(im(y:y+h-1, x+w:x+2*w-1)))+sum(sum(im(y+h:y+2*h-1, x:x+w-1)))-sum(sum(im(y:y+h-1, x:x+w-1)))-sum(sum(im(y+h:y+2*h-1, x+w:x+2*w-1)))

%%
 dinfo2 = load('DebugInfo/debuginfo2.mat');
 x = dinfo2.x; y = dinfo2.y; w = dinfo2.w; h = dinfo2.h;
 abs(dinfo2.f1 - FeatureTypeI(ii_im, x, y, w, h)) > eps
 abs(dinfo2.f2 - FeatureTypeII(ii_im, x, y, w, h)) > eps
 abs(dinfo2.f3 - FeatureTypeIII(ii_im, x, y, w, h)) > eps
 abs(dinfo2.f4 - FeatureTypeIV(ii_im, x, y, w, h)) > eps
 
 %% The forever loop
 tic
 a= EnumAllFeatures(19,19);
 toc