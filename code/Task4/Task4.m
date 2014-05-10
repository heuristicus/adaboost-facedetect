%% Task 4
% Face Detection by Sub-Windows in a larger image
load('data/Cparams10ftr.mat');
im=imread('data/TrainingImages/FACES/face00001.bmp');
W=19;
H=19;
% Display score using normalized Features
dets = ScanImageFixedSize(Cparams, im, W, H);
% Display score using LoadIm
[~, ii_im] = LoadIm('data/TrainingImages/FACES/face00001.bmp');
score = ApplyDetector(Cparams, ii_im)

%% Load 
im =imread('data/TestImages/one_chris.png');
W=19;
H=19;
dets = ScanImageFixedSize(Cparams, im, W, H);
%%
im =imread('data/TestImages/one_chris.png');
DisplayDetections(im, dets)

%% test pruning detections with manually defined test boxes
close all
% overlapping boxes are in pairs.
boxes = [1 1 3 3;
         2 2 3 3;
         7 1 3 3;
         8 0 3 3;
         13 1 3 3;
         12 2 3 3;
         18 1 3 3;
         17 0 3 3;
         1 9 3 3;
         1 8 3 3;
         7 9 3 3;
         8 9 3 3;
         14 9 3 3;
         14 10 3 3;
         20 9 3 3;
         19 9 3 3];

% show all of the boxes that we will be looking at
im = ones(14, 25) * 255;

figure
image(im)
colormap('gray')
axis equal
hold on
for i=1:size(boxes,1)
    if (mod(i-1,2) == 0)
        colour = 'r';
    else
        colour = 'b';
    end
    rectangle('Position', boxes(i,:),'EdgeColor',colour)
end
hold off

colormap('gray')
pruned = PruneDetections(boxes, 0.4);

figure
image(im)
colormap('gray')
axis equal
hold on
for i=1:size(boxes,1)
    rectangle('Position', boxes(i,:),'EdgeColor','r')
end
for i=1:size(pruned,1)
    rectangle('Position', pruned(i,:),'EdgeColor','b')
end
hold off

%% test pruning with quite a few overlapping boxes

close all
boxes = [1 0 3 3;
         1 2 3 3;
         2 1 3 3;
         0 1 3 3];
     
% show all of the boxes that we will be looking at
im = ones(14, 25) * 255;

figure
image(im)
colormap('gray')
axis equal
hold on
for i=1:size(boxes,1)
    rectangle('Position', boxes(i,:),'EdgeColor','r')
end

colormap('gray')
pruned = PruneDetections(boxes, 0.4);

for i=1:size(pruned,1)
    rectangle('Position', pruned(i,:),'EdgeColor','b')
end

%%

im =imread('data/TestImages/one_chris.png');
W=19;
H=19;
dets = ScanImageOverScale(Cparams, im, 0.5, 1.5, 0.5);
DisplayDetections(im, dets)
